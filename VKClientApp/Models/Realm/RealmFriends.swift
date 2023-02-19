//
//  RealmFriends.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 26.03.2022.
//

import Foundation
import RealmSwift

class RealmFriends: Object{
    @Persisted(primaryKey: true) var friendId: Int
    @Persisted var friendFirstName: String = ""
    @Persisted var friendLastName: String = ""
    @Persisted var friendPhoto: String = ""
    }

extension RealmFriends {
    convenience init(friends: FriendItem) {
        self.init()
        self.friendId = friends.friendID
        self.friendFirstName = friends.friendFirstName
        self.friendLastName = friends.friendLastName
        self.friendPhoto = friends.friendPhoto
    }
}
