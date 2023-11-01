//
//  DefaultNetworkRepository.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/09/20.
//

import Foundation

final class DefaultNetworkRepository {
    private let networkService = NetworkService()
    
    func getAllUserDetails(completion: @escaping (Result<[User], Error>) -> Void) {
        let urlString = URL(string: "https://127.0.0.1:8080")!
        let request = URLRequest(url: urlString)
        
        networkService.request(request) { result in
            switch result {
            case .success(let userData):
                do {
                    let users = try JSONDecoder().decode([User].self, from: userData)
                    completion(.success(users))
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
