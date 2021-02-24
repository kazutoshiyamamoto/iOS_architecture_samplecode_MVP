//
//  Session.swift
//  MVP
//
//  Created by home on 2021/02/19.
//  Copyright © 2021 Swift-beginners. All rights reserved.
//

import Foundation

// エラーの種類を列挙
enum SessionError: Error {
    case noData(HTTPURLResponse)
    case noResponse
    case unacceptableStatusCode(Int, Message?)
    case failedToCreateComponents(URL)
    case failedToCreateURL(URLComponents)
}

final class Session {
    private let accessToken: () -> AccessToken?
    private let additionalHeaderFields: () -> [String: String]?
    private let session: URLSession

    init(
                // " = { () -> AccessToken in return nil }"はデフォルト引数
                // 代入する引数の型が明確なので、"() -> AccessToken"は省略可能
                // 引数の型の表記が省略できるなら、引数名も省略可能
                // 引数の型の表記も省略する場合は"in"も省略しないとコンパイルエラーになるので注意
                // クロージャ内の文がひとつしかないのでreturnは省略可能
                accessToken: @escaping () -> AccessToken? = { () -> AccessToken in return nil },
                // 1行上のaccessTokenの記法を省略する（クロージャの省略記法を使う）と{ nil }になる
                additionalHeaderFields: @escaping () -> [String: String]? = { nil },
                session: URLSession = .shared) {
        self.accessToken = accessToken
        self.additionalHeaderFields = additionalHeaderFields
        self.session = session
    }
    
    // "@discardableResult"は関数の返り値を使用しない場合に使用する
    @discardableResult
    func send<T: Request>(_ request: T, completion: @escaping (Result<(T.Response, Pagination)>) -> ()) -> URLSessionTask? {
        // GitHub APIのリクエストURLに追加のパラメータを追加している
        // appendingPathComponentの参考:https://developer.apple.com/documentation/foundation/url/1780239-appendingpathcomponent
        // "baseURL"はプロトコルRequestの値
        // "request.path"はプロトコルRequestに準拠した構造体（例えばSearchUsersRequest）に値が定義してある
        let url = request.baseURL.appendingPathComponent(request.path)
        
        // "resolvingAgainstBaseURL = true"はフルパス表記であることを示している
        // 参考:https://stackoverflow.com/questions/38720933/whats-the-difference-between-passing-false-and-true-to-resolvingagainstbaseurl
        guard var componets = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(SessionError.failedToCreateComponents(url)))
            return nil
        }
        // queryParametersの型（String : String）の配列をURLQueryItem.initの型(name: String, value: String?)の配列に変換している
        // compactMapなのでオプショナル（初期化する際に値の指定がない（nil）の場合）の値は無視して変換している
        // compactMap:https://developer.apple.com/documentation/swift/sequence/2950916-compactmap
        componets.queryItems = request.queryParameters?.compactMap(URLQueryItem.init)
        
        guard var urlRequest = componets.url.map({ URLRequest(url: $0) }) else {
            completion(.failure(SessionError.failedToCreateURL(componets)))
            return nil
        }
        
        urlRequest.httpMethod = request.method.rawValue
        
        let headerFields: [String: String]
        // おそらく、Sessionクラスがインスタンス化した時に、引数additionalHeaderFieldsが指定されていないとadditionalHeaderFieldsはnilになっているはず
        // "if let additionalHeaderFields = additionalHeaderFields()"は、
        // 「インスタンス化した時に、引数additionalHeaderFieldsが指定されていた場合は」という条件のような気がする
        if let additionalHeaderFields = additionalHeaderFields() {
            // "uniquingKeysWith: +"は重複したKeyはValueを合計するオペレータ
            headerFields = request.headerFields.merging(additionalHeaderFields, uniquingKeysWith: +)
        } else {
            headerFields = request.headerFields
        }
        if let token = accessToken() {
            let authorization = ["Authorization": "token \(token.accessToken)"]
            urlRequest.allHTTPHeaderFields = headerFields.merging(authorization, uniquingKeysWith: +)
        } else {
            urlRequest.allHTTPHeaderFields = headerFields
        }
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(SessionError.noResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(SessionError.noData(response)))
                return
            }
            
            guard  200..<300 ~= response.statusCode else {
                let message = try? JSONDecoder().decode(SessionError.Message.self, from: data)
                completion(.failure(SessionError.unacceptableStatusCode(response.statusCode, message)))
                return
            }
            
            let pagination: Pagination
            if let link = response.allHeaderFields["Link"] as? String {
                pagination = Pagination(link: link)
            } else {
                pagination = Pagination(next: nil, last: nil, first: nil, prev: nil)
            }
            
            do {
                let object = try JSONDecoder().decode(T.Response.self, from: data)
                completion(.success((object, pagination)))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        
        return task
    }
}

extension SessionError {
    // エラー用のDecodable（正常系のCodableはEntityに実装されている）
    // CodableはDecodableとEncodableのエイリアス
    struct Message: Decodable {
        let documentationURL: URL
        let message: String
        
        private enum CodingKeys: String, CodingKey {
            case documentationURL = "documentation_url"
            case message
        }
    }
}
