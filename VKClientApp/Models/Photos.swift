//
//  Photos.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 20.02.2022.
//

struct PhotosResponce: Codable  {
    let response: PhotosItemsResponse
}

struct PhotosItemsResponse {
    let photos: [Photos]
}

extension PhotosItemsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case photos = "items"
    }
}

struct Photos {
    let userID: Int
    let photoSizes: [Sizes]
}

extension Photos: Codable {
    enum CodingKeys: String, CodingKey {
        case userID = "owner_id"
        case photoSizes = "sizes"
    }
}

struct Sizes {
    let photoHeight: Int
    let photoWidth: Int
    let photoUrl: String
}

extension Sizes:Codable {
    enum CodingKeys: String, CodingKey {
        case photoHeight = "height"
        case photoWidth = "width"
        case photoUrl = "url"
    }
}
