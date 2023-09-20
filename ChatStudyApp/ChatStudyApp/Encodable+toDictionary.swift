//
//  Encodable+Ext.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            let dict = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            return dict ?? .init()
        } catch {
            return .init()
        }
    }
}
