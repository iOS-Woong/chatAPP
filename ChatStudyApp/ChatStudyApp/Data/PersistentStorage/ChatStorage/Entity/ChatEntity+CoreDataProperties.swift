//
//  ChatEntity+CoreDataProperties.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/22.
//
//

import Foundation
import CoreData


extension ChatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEntity> {
        return NSFetchRequest<ChatEntity>(entityName: "ChatEntity")
    }

    @NSManaged public var chatID: Int64
    @NSManaged public var createDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var timestamp: Date?
    @NSManaged public var type: String?
    @NSManaged public var chat: ChatRoomEntity?

}

extension ChatEntity : Identifiable {

}
