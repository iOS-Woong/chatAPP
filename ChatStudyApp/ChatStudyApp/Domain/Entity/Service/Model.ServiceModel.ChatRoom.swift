//
//  Model.ServiceModel.ChatRoom.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension Model.ServiceModel {
    struct ChatRoom {
        let roomId: Int
        let roomType: String
        let name: String
        let lastChat: String
        let senderId: Int
        let url: String
        let users: [User]
        let chats: [Chat]
        
        init(json: [String: Any]) {
            roomId = json["roomId"].flatMap { $0 as? Int } ?? .zero
            roomType = json["roomType"].flatMap { $0 as? String } ?? ""
            name = json["name"].flatMap { $0 as? String } ?? ""
            lastChat = json["lastChat"].flatMap { $0 as? String } ?? ""
            senderId = json["senderId"].flatMap { $0 as? Int } ?? .zero
            url = json["url"].flatMap { $0 as? String } ?? ""
            
            users = json["users"]
                .flatMap { $0 as? [[String: Any]] }?
                .map(Model.ServiceModel.User.init) ?? []
            chats = json["chats"]
                .flatMap { $0 as? [[String: Any]] }?
                .map(Model.ServiceModel.Chat.init) ?? []
        }
    }
}
