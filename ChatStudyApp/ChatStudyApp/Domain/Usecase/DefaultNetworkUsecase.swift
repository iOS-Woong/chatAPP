//
//  DefaultNetworkUsecase.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/11/01.
//

import Foundation

final class DefaultNetworkUsecase {
    
    private let defaultNetworkRepository = DefaultNetworkRepository()
    
    func getAllUserDetails(completion: @escaping (Result<[User], Error>) -> Void) {
        defaultNetworkRepository.getAllUserDetails { result in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
