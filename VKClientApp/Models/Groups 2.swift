//
//  Group.swift
//  VKClientApp
//
//  Created by Sergey Simashov on 23.11.2021.
//
//struct Group {
//    var name: String
//    var avatar: String?
//}

struct GroupsResponse: Codable {
    let response: GroupsItemsResponse
}


struct GroupsItemsResponse {
    let groups: [GroupsItems]
}

extension GroupsItemsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case groups = "items"
    }
}

struct GroupsItems {
    let groupID: Int
    let groupName: String
    let groupPhoto: String
}


extension GroupsItems: Codable {
    enum CodingKeys: String, CodingKey {
               case groupID = "id"
               case groupName = "name"
               case groupPhoto = "photo_100"
    }
}
