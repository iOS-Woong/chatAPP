//
//  FriendCollectionViewCell.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/10/04.
//

import UIKit

class FriendCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { String(describing: self) }
    
    private let profileImageView = UIImageView()
    private let labelStackView = UIStackView()
    private let nameLabel = UILabel()
    private let stateMessageLabel = UILabel()
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureSubviews()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Internal
    
    func configure(user: User) {
        profileImageView.backgroundColor = .green
//        profileImageView.image = UIImage(systemName: "cloud") // TODO: 이미지캐시로 변경
        nameLabel.text = user.name
        stateMessageLabel.text = user.userDescription
    }
    
    // MARK: Private
    
    private func configureSubviews() {
        configureProfileImageView()
        configureNameLabel()
        configureStateMessageLabel()
        configureLableStackView()
    }
    
    private func configureProfileImageView() {
        profileImageView.layer.cornerRadius = 15
    }
    
    private func configureLableStackView() {
        labelStackView.axis = .vertical
        labelStackView.spacing = 5
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
    }
    
    private func configureNameLabel() {
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    private func configureStateMessageLabel() {
        stateMessageLabel.textColor = .black
        stateMessageLabel.textAlignment = .left
        stateMessageLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
    }
    
    private func configureHierarchy() {
        [nameLabel, stateMessageLabel]
            .forEach { labelStackView.addArrangedSubview($0) }
        [profileImageView, labelStackView]
            .forEach { contentView.addSubview($0) }
    }
    
    private func configureLayout() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
