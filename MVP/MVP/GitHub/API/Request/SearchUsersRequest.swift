//
//  SearchUsersRequest.swift
//  MVP
//
//  Created by home on 2021/02/20.
//  Copyright © 2021 Swift-beginners. All rights reserved.
//

/// - seealso: https://developer.github.com/v3/search/#search-users
struct SearchUsersRequest: Request {
    typealias Response = ItemsResponse<User>
    
    let method: HttpMethod = .get
    let path = "/search/users"
    
    var queryParameters: [String : String]? {
        var params: [String: String] = ["q": query]
        if let page = page {
            params["page"] = "\(page)"
        }
        if let perPage = perPage {
            params["per_page"] = "\(perPage)"
        }
        if let sort = sort {
            params["sort"] = sort.rawValue
        }
        if let order = order {
            params["order"] = order.rawValue
        }
        return params
    }
    
    let query: String
    let sort: Sort?
    let order: Order?
    let page: Int?
    let perPage: Int?
    
    init(query: String, sort: Sort?, order: Order?, page: Int?, perPage: Int?) {
        self.query = query
        self.sort = sort
        self.order = order
        self.page = page
        self.perPage = perPage
    }
}

extension SearchUsersRequest {
    enum Sort: String {
        case followers
        case repositories
        case joined
    }
    
    enum Order: String {
        case asc
        case desc
    }
}

