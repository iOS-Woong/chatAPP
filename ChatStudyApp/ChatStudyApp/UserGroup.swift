//
//  UserGroup.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/09/27.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int?
    let name: String
    let group: Group?
    let imageUrl: String?
    let userDescription: String
}

struct Group: Codable {
    let id: Int?
    let name: String
}
