//
//  AllGroups.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 23.02.2022.
//
//
//
//struct AllGroupsResponse: Codable {
//    let response: AllGroupsItemsResponse
//}
//
//
//struct AllGroupsItemsResponse {
//    let groups: [AllGroups]
//}
//
//extension AllGroupsItemsResponse: Codable {
//    enum CodingKeys: String, CodingKey {
//        case groups = "items"
//    }
//}
//
//struct AllGroups {
//    let groupID: Int
//    let groupName: String
//    let groupPhoto: String
//}
//
//
//extension AllGroups: Codable {
//    enum CodingKeys: String, CodingKey {
//               case groupID = "id"
//               case groupName = "name"
//               case groupPhoto = "photo_100"
//    }
//}
