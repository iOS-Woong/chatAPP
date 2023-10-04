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
        configureCollectionViewLayout()
        configureCollectionViewAttributes()
        configureHierarchy()
        configureLayout()
    }
    
    // MARK: Private
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: view.frame.width, height: 48)
        layout.minimumInteritemSpacing = 12
        
        friendListCollectionView.collectionViewLayout = layout
    }
    
    private func configureCollectionViewAttributes() {
        view.backgroundColor = .black
        
        friendListCollectionView.backgroundColor = .clear
        friendListCollectionView.register(
            FriendCollectionViewCell.self,
            forCellWithReuseIdentifier: FriendCollectionViewCell.identifier)
        friendListCollectionView.dataSource = self
        friendListCollectionView.delegate = self
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
        return viewModel.mock.count
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
        
        cell.configure(user: viewModel.mock[indexPath.row])
        
        return cell
    }
}

extension FriendListViewController: UICollectionViewDelegate {
    
}
