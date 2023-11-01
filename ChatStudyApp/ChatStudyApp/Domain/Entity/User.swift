//
//  User.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/01.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: Int?
    let name: String
    let group: Group?
    let imageUrl: String?
    let userDescription: String
}
