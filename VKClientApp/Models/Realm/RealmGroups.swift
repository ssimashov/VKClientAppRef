//
//  RealmGroups.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 26.03.2022.
//

import Foundation
import RealmSwift

class RealmGroups: Object {
    @Persisted(primaryKey: true) var groupId: Int = Int()
    @Persisted var groupName: String = ""
    @Persisted var groupPhoto: String = ""
}

extension RealmGroups {
    convenience init(groups: GroupsItems) {
        self.init()
        self.groupId = groups.groupID
        self.groupName = groups.groupName
        self.groupPhoto = groups.groupPhoto
    }
}

