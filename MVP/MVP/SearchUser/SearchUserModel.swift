//
//  SearchUserModelInput.swift
//  MVP
//
//  Created by home on 2020/06/25.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import Foundation
import GitHub

protocol SearchUserModelInput {
    // リクエスト処理
    func fetchUser(
        query: String,
        completion: @escaping (Result<[User]>) -> ())
}

final class SearchUserModel: SearchUserModelInput {
    // ユーザー情報を取得
    func fetchUser(
        query: String,
        completion: @escaping (Result<[User]>) -> ()) {
        let session = GitHub.Session()
        let request = SearchUsersRequest(
            query: query,
            sort: nil,
            order: nil,
            page: nil,
            perPage: nil)
        
        session.send(request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.0.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
