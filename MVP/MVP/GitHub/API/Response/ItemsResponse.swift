//
//  ItemsResponse.swift
//  MVP
//
//  Created by home on 2021/02/20.
//  Copyright © 2021 Swift-beginners. All rights reserved.
//

import Foundation

struct ItemsResponse<Item: Decodable>: Decodable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
    
    init(totalCount: Int, incompleteResults: Bool, items: [Item]) {
        self.totalCount = totalCount
        self.incompleteResults = incompleteResults
        self.items = items
    }
}
