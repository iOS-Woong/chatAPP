//
//  MockSocket.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import Foundation
import Moya

// 1.소켓

final class MockSocket {
    let provider = MoyaProvider<DefaultAPI>()
    
    func requestGet() {
        provider.request(.get) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestPost() {
        provider.request(.post(PostRequestModel.mock)) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

