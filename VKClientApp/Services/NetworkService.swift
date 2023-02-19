//
//  NetworkService.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 13.02.2022.
//

import Foundation

final class NetworkService {

    let session = URLSession.shared
    
    lazy var mySession = URLSession(configuration: configuration)
    let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10.0
        config.httpAdditionalHeaders = [
            "token": "someToken",
        ]
        return config
    }()
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        
        return constructor
    }()
    
    func fetchFriends(userID: Int, completion: @escaping (Result<[FriendItem], Error>) -> Void){
        
        var constructor = urlConstructor
        let userID = userID
        
        constructor.path = "/method/friends.get"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: String(userID)),
            URLQueryItem(name: "fields", value: "photo_100"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = constructor.url else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let friendResponse = try JSONDecoder().decode(
                    FriendsResponse.self,
                    from: data)
                completion(.success(friendResponse.response.friends))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchPhotos(userID: Int, completion: @escaping (Result<[Photos], Error>) -> Void) {
        
        var constructor = urlConstructor
        let userID = userID
        constructor.path = "/method/photos.getAll"
        constructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(userID)),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = constructor.url else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let response = response as? HTTPURLResponse {
                print(response.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            do {
                let photosResponse = try JSONDecoder().decode(
                    PhotosResponce.self,
                    from: data)
                completion(.success(photosResponse.response.photos))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
// MARK: - fetching groups
    
    func fetchGroups(userID:Int, completion: @escaping (Result<[GroupsItems], Error>) -> Void){
        
        var constructor = urlConstructor
        let userID = userID
        
        constructor.path = "/method/groups.get"
        constructor.queryItems = [
            URLQueryItem(name: "owner_id", value: String(userID)),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = constructor.url else { return }
        
        let task = session.dataTask(with: url) { data, responce, error in
            if let responce = responce as? HTTPURLResponse {
                print(responce.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            
            do {
                let groupsResponse = try JSONDecoder().decode(
                    GroupsResponse.self,
                    from: data)
                completion(.success(groupsResponse.response.groups))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
// MARK: - fetching all groups
    func fetchAllGroups(query: String, completion: @escaping (Result<[GroupsItems], Error>) -> Void){
        
        var constructor = urlConstructor
//        let query = query
        
        constructor.path = "/method/groups.search"
        constructor.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131")
        ]
        
        guard let url = constructor.url else { return }
        
        let task = session.dataTask(with: url) { data, responce, error in
            if let responce = responce as? HTTPURLResponse {
                print(responce.statusCode)
            }
            guard
                error == nil,
                let data = data
            else { return }
            
            do {
                let allGroupsResponse = try JSONDecoder().decode(
                    GroupsResponse.self,
                    from: data)
                completion(.success(allGroupsResponse.response.groups))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
