//
//  Model.ServiceModel.Group.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension Model.ServiceModel {
    struct Group {
        let id: Int
        let name: String
        
        init(json: [String: Any]) {
            id = json["id"].flatMap { $0 as? Int } ?? .zero
            name = json["name"].flatMap { $0 as? String } ?? ""
        }
    }
}
