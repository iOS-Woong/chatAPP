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
        socket()
        setupViews()
        configureButton()
        sendButtonAction()
        view.backgroundColor = .white
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
    
}

extension ChatViewController: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?)
    {
        print("OPEN")
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?)
    {
        print("CLOSE")
    }
    
}
