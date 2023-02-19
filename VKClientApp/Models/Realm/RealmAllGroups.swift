//
//  RealmAllGroups.swift
//  VKClientAppCS
//
//  Created by Sergey Simashov on 26.03.2022.
//

import Foundation
import RealmSwift

class RealmAllGroups: Object {
    @Persisted(primaryKey: true) var groupId: Int = Int()
    @Persisted var groupName: String = ""
    @Persisted var groupPhoto: String = ""
}

extension RealmAllGroups {
    convenience init(allGroupsName: String, groups: GroupsItems) {
        self.init()
        self.groupId = groups.groupID
        self.groupName = groups.groupName
        self.groupPhoto = groups.groupPhoto
    }
}

