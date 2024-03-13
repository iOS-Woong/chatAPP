//
//  API.ResponseModel.ResponseChat.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension API.ResponseModel {
    struct ResponseChat {
        let ChatRoom: [Model.ServiceModel.ChatRoom]
        
        init(json: [String: Any]) {
            ChatRoom = json["chatRooms"]
                .flatMap { $0 as? [[String: Any]] }?
                .map(Model.ServiceModel.ChatRoom.init) ?? []
        }
    }
}
