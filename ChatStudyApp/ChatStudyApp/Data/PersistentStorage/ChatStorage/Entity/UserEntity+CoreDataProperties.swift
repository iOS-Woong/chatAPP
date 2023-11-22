//
//  UserEntity+CoreDataProperties.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/22.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var userDescription: String?
    @NSManaged public var chat: ChatRoomEntity?
    @NSManaged public var groupID: GroupEntity?

}

extension UserEntity : Identifiable {

}
