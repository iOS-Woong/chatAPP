//
//  APIRequester.swift
//  WeatudyClone
//
//  Created by pyo on 2024/03/13.
//

import Foundation

protocol APIRequester {
    associatedtype ResponseType

    func withError(errorCode: Int) -> ErrorType
    func parse(_ json: [String: Any]) -> ResponseType
}
