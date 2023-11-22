//
//  ChatRoomEntity+CoreDataProperties.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/22.
//
//

import Foundation
import CoreData


extension ChatRoomEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoomEntity> {
        return NSFetchRequest<ChatRoomEntity>(entityName: "ChatRoomEntity")
    }

    @NSManaged public var lastChatDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var roomID: Int64
    @NSManaged public var roomType: String?
    @NSManaged public var url: String?
    @NSManaged public var chats: NSOrderedSet?
    @NSManaged public var senders: NSSet?

}

// MARK: Generated accessors for chats
extension ChatRoomEntity {

    @objc(insertObject:inChatsAtIndex:)
    @NSManaged public func insertIntoChats(_ value: ChatEntity, at idx: Int)

    @objc(removeObjectFromChatsAtIndex:)
    @NSManaged public func removeFromChats(at idx: Int)

    @objc(insertChats:atIndexes:)
    @NSManaged public func insertIntoChats(_ values: [ChatEntity], at indexes: NSIndexSet)

    @objc(removeChatsAtIndexes:)
    @NSManaged public func removeFromChats(at indexes: NSIndexSet)

    @objc(replaceObjectInChatsAtIndex:withObject:)
    @NSManaged public func replaceChats(at idx: Int, with value: ChatEntity)

    @objc(replaceChatsAtIndexes:withChats:)
    @NSManaged public func replaceChats(at indexes: NSIndexSet, with values: [ChatEntity])

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: ChatEntity)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: ChatEntity)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSOrderedSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSOrderedSet)

}

// MARK: Generated accessors for senders
extension ChatRoomEntity {

    @objc(addSendersObject:)
    @NSManaged public func addToSenders(_ value: UserEntity)

    @objc(removeSendersObject:)
    @NSManaged public func removeFromSenders(_ value: UserEntity)

    @objc(addSenders:)
    @NSManaged public func addToSenders(_ values: NSSet)

    @objc(removeSenders:)
    @NSManaged public func removeFromSenders(_ values: NSSet)

}

extension ChatRoomEntity : Identifiable {

}
