//
//  DefaultAPI.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import Foundation
import Moya

enum DefaultAPI {
    case get
    case post(PostRequestModel)
}

extension DefaultAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://127.0.0.1:8080")!
    }
    
    var path: String {
        switch self {
        case .get: return ""
        case .post: return "/write"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get: return .get
        case .post: return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .get:
            return .requestPlain
        case .post(let requestModel):
            return .requestJSONEncodable(requestModel)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .get:
            return ["Content-Type": "application/json"]
        case .post:
            return ["Content-Type": "application/json"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
