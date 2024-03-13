//
//  Model.ServiceModel.Sender.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension Model.ServiceModel {
    struct Sender {
        let id: String
        let group_id: String
        let name: String
        let imageUrl: String
        let userDescription: String
        let group: Group
        
        init(json: [String: Any]) {
            id = json["id"].flatMap { $0 as? String } ?? ""
            group_id = json["group_id"].flatMap { $0 as? String } ?? ""
            name = json["name"].flatMap { $0 as? String } ?? ""
            imageUrl = json["imageUrl"].flatMap { $0 as? String } ?? ""
            userDescription = json["userDescription"].flatMap { $0 as? String } ?? ""
            
            group = json["group"]
                .flatMap { $0 as? [String: Any] }?
                .map(Model.ServiceModel.Group.init) ?? Model.ServiceModel.Group(json: [:])
        }
    }
}
