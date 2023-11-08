//
//  ViewController.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/01.
//

import UIKit

class FriendListViewController: UIViewController {
    
    private let viewModel: FriendListViewModel
    private let friendListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: Lifecycle
    
    init(viewModel: FriendListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureNavigation()
        configureCollectionViewLayout()
        configureCollectionViewAttributes()
        configureHierarchy()
        configureLayout()
        viewModel.getAllUserDetails()
    }
    
    // MARK: Private
    
    private func bind() {
        viewModel.didChangeUsers = {
            DispatchQueue.main.async {
                self.friendListCollectionView.reloadData()
            }
        }
    }
    
    private func configureNavigation() {
        title = "ChatList"
    }
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: view.frame.width, height: 48)
        layout.minimumInteritemSpacing = 12
        
        friendListCollectionView.collectionViewLayout = layout
    }
    
    private func configureCollectionViewAttributes() {
        view.backgroundColor = .white
        
        friendListCollectionView.backgroundColor = .clear
        friendListCollectionView.register(
            FriendCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        friendListCollectionView.dataSource = self
    }
    
    private func configureHierarchy() {
        view.addSubview(friendListCollectionView)
    }
    
    private func configureLayout() {
        friendListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            friendListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            friendListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FriendListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
    -> Int
    {
        return viewModel.users.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FriendCollectionViewCell.identifier,
            for: indexPath) as? FriendCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(user: viewModel.users[indexPath.row])
        
        return cell
    }
}

/*
 
 // 임시
 func requestPOST() {
     let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
     
     let url = URL(string: "https://127.0.0.1:8080/user_register")!
     var request = URLRequest(url: url)
     request.httpMethod = "POST"
     
     let userToBeAdded = [
         "name": "woong23Test",
         "imageUrl": "https://example.com/image.jpg",
         "userDescription": "설명입니다"
     ]
     
     do {
         request.httpBody = try JSONSerialization.data(withJSONObject: userToBeAdded, options: [])
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     } catch {
         print(error.localizedDescription)
         return
     }
     
     session.dataTask(with: request) { data, response, error in
         print(String(data: data!, encoding: .utf8))
     }.resume()
 }
 */
