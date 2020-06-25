//
//  SearchUserModelInput.swift
//  MVP
//
//  Created by home on 2020/06/25.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import Foundation

protocol SearchUserModelInput {
    func fetchUser(
        query: String,
        completion: @escaping (Result<[User]>) -> ())
}

final class SearchUserModel: SearchUserModelInput {
    
}
