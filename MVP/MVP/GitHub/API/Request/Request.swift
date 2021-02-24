//
//  Request.swift
//  MVP
//
//  Created by home on 2021/02/20.
//  Copyright © 2021 Swift-beginners. All rights reserved.
//

import Foundation

protocol Request {
    associatedtype Response: Decodable
    
    // "{ get }"は、「protocolを付加したクラス」を利用するクラスからは、読み込みしかできない、という意味（getのプロパティだから）
    // または、Requestプロトコルに準拠していれば"{ get }"が使えるという意味
    // 参考:https://teratail.com/questions/102550
    var baseURL: URL { get }
    var method: HttpMethod { get }
    var path: String { get }
    var headerFields: [String: String] { get }
    var queryParameters: [String: String]? { get }
}

extension Request {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var headerFields: [String: String] {
        return ["Accept": "application/json"]
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
}

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
