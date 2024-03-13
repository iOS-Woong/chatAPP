//
//  API.RequsetModel.SendChat.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension API.RequsetModel {
    struct SendChat: APIRequester {
        let createDate: String
        let chatType: ChatType
        let message: String
        let room: Room
        let sender: Sender
        
        struct Room {
            let roomID: Int
            let roomType: Int
            let name: String
            let url: String
            let senderID: Int
            let userIds: [Int]
        }
        
        struct Group {
            let id: Int
            let name: String
        }
        
        struct Sender {
            let group: Group
            let id: Int
            let name: String
            let imageUrl: String?
            let userDescription: String
        }
        
        init(
            createDate: String,
            chatType: ChatType,
            message: String,
            room: Room,
            sender: Sender
        ) {
            self.createDate = createDate
            self.chatType = chatType
            self.message = message
            self.room = room
            self.sender = sender
        }
        
        func withError(errorCode: Int) -> ErrorType {
            .none
        }
        
        func parse(_ json: [String: Any]) -> API.ResponseModel.ResponseChat {
            return json.parse(API.ResponseModel.ResponseChat.init)
        }
    }
}
