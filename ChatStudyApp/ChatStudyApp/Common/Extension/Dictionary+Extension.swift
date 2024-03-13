//
//  Dictionary+Extension.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

extension Dictionary where Key == String, Value == Any {
    func parse<R>(_ json: (Dictionary) -> R) -> R {
        return json(self)
    }
}
