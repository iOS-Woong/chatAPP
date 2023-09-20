//
//  NetworkService.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/09/20.
//

import Foundation

enum NetworkError: Error {
    case invalidData
    case invalidHTTPStatusCode(statusCode: Int)
    case invalidResponse
    case invalidRequest
    case invalidURL
}

final class NetworkService {
    func request(
        _ request: URLRequest?,
        completion: @escaping (Result<Data, NetworkError>) -> Void
    ) -> URLSessionTask? {
        guard let request else {
            completion(.failure(.invalidURL))
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.invalidRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200..<300) ~= response.statusCode else {
                completion(.failure(.invalidHTTPStatusCode(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
        
        return task
    }
}
