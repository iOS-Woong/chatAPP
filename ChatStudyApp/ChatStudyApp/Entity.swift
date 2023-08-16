//
//  Entity.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import Foundation

struct Sender {
    var name: String
}

struct Message {
    var messageId: Int
    var sender: Sender
    var imageURL: String
    var context: String
}
