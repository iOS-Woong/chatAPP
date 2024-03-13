//
//  Model.ServiceModel.Chat.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension Model.ServiceModel {
    struct Chat {
        let chatId: Int
        let createDate: String
        let chatType: ChatType
        let message: String
        let sender: Sender
        let url: String?
        let thumbnailURL: String?
        let width: CGFloat?
        let height: CGFloat?
        
        init(json: [String: Any]) {
            chatId = json["chatId"].flatMap { $0 as? Int } ?? .zero
            createDate = json["createDate"].flatMap { $0 as? String } ?? ""
            chatType = json["chatType"].flatMap { $0 as? Int }
                .flatMap(ChatType.init) ?? .textChat
            message = json["message"].flatMap { $0 as? String } ?? ""
            sender = json["sender"].flatMap { $0 as? [String: Any] }
                .map(Sender.init) ?? Sender(json: [:])
            url = json["url"].flatMap { $0 as? String } ?? ""
            thumbnailURL = json["thumbnailURL"].flatMap { $0 as? String } ?? ""
            width = json["width"].flatMap { $0 as? CGFloat } ?? .zero
            height = json["height"].flatMap { $0 as? CGFloat } ?? .zero
        }
    }
}
