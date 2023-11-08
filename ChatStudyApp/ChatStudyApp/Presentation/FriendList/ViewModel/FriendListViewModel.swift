//
//  FriendListViewModel.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/09/20.
//

import Foundation

final class FriendListViewModel {
    
    private let networkUsecase = DefaultNetworkUsecase()
    
    var didChangeUsers: (() -> Void)?
    var users: [User] = [User]() {
        didSet {
            didChangeUsers?()
        }
    }
    
    func getAllUserDetails() {
        networkUsecase.getAllUserDetails { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
