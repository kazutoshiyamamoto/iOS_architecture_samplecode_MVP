//
//  User.swift
//  MVP
//
//  Created by home on 2021/02/19.
//  Copyright © 2021 Swift-beginners. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let id: Int
    let nodeID: String
    let avatarURL: URL
    let gravatarID: String
    let url: URL
    let receivedEventsURL: URL
    let type: String
    
    private enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case receivedEventsURL = "received_events_url"
        case type
    }
    
    init(login: String,
         id: Int,
         nodeID: String,
         avatarURL: URL,
         gravatarID: String,
         url: URL,
         receivedEventsURL: URL,
         type: String) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.receivedEventsURL = receivedEventsURL
        self.type = type
    }
}