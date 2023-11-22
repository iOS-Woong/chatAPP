//
//  GroupEntity+CoreDataProperties.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/22.
//
//

import Foundation
import CoreData


extension GroupEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GroupEntity> {
        return NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var user: UserEntity?

}

extension GroupEntity : Identifiable {

}
