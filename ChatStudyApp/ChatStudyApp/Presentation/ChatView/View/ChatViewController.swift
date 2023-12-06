//
//  ChatViewController.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import UIKit
import MessageKit

struct TestSender: SenderType {
    var senderId: String
    var displayName: String
}

struct TestMessage: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

final class ChatViewController: MessagesViewController {
    
    private let chatViewModel: ChatViewModel
    
    init(chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupMessagesCollectionViewAttributes()
    }
    
    private func setupMessagesCollectionViewAttributes() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
//        customizeMessagesCollectionViewLayout()
//        cellResistration()
//        configureMessagesCollectionViewBackgroundColor()
        messagesCollectionView.reloadData()
    }
}

// MARK: MesagesDataSource

extension ChatViewController: MessagesDataSource {
    var currentSender: MessageKit.SenderType {
        return TestSender(senderId: "0", displayName: "me")
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessageKit.MessagesCollectionView)
        -> MessageKit.MessageType
    {
        return TestMessage(sender: TestSender(senderId: "dd", displayName: "hi"), messageId: "hi", sentDate: Date(), kind: .text("안녕"))
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int
    {
        return 1
    }
}

// MARK: MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
}

// MARK: MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
}
