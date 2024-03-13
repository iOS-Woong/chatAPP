//
//  ChatType.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

enum ChatType: Int, RawRepresentable {
    case textChat = 1
    case imageChat
    
    var rawValue: String {
        switch self {
        case .textChat:
            "textChat"
        case .imageChat:
            "imageChat"
        }
    }
}
