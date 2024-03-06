//
//  ChatViewController.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import UIKit

class ChatViewController: UIViewController {
    private let sendButton: UIButton = UIButton(frame: .zero)
    let webSocket = WebSocket.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        socket()
        setupViews()
        configureButton()
        sendButtonAction()
        view.backgroundColor = .white
        requestPOST()
    }
    
    func request() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let url = URL(string: "https://127.0.0.1:8080")!
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            print(data)
        }.resume()
    }
    
    func requestPOST() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let url = URL(string: "https://127.0.0.1:8080/user_register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let userToBeAdded = [
            "name": "woong",
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
    
    func socket() {
        try? webSocket.openWebSocket()
        webSocket.delegate = self
        
        webSocket.onReceiveClosure = { (string, data) in
            print(string, data)
        }
    }
    
    private func configureButton() {
        sendButton.backgroundColor = .systemBlue
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.black, for: .normal)
    }
    
    private func setupViews() {
        view.addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            sendButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func sendButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.webSocket.send(message: "hello world")
        }
        
        sendButton.addAction(action, for: .touchUpInside)
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

extension ChatViewController: URLSessionWebSocketDelegate {
//    func urlSession(
//        _ session: URLSession,
//        webSocketTask: URLSessionWebSocketTask,
//        didOpenWithProtocol protocol: String?)
//    {
//        print("OPEN")
//    }
//
//    func urlSession(
//        _ session: URLSession,
//        webSocketTask: URLSessionWebSocketTask,
//        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
//        reason: Data?)
//    {
//        print("CLOSE")
//    }
    
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?)
        -> Void)
    {
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    
}
