//
//  ChatViewController.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import UIKit
import Alamofire

class ChatViewController: UIViewController {

    private let testTextView = UITextView()
    private let testButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutConstratint()
        testTextView.text = "default"
        configureTestButton()
    }
    
    private func configureTestButton() {
        testButton.setTitle("Notification", for: .normal)
        testButton.setTitleColor(UIColor.black, for: .normal)
        testButton.backgroundColor = .systemBlue
        configureButtonAction()
    }
    
    private func configureButtonAction() {
        let action = UIAction { _ in
            Task {
                do {
                    try await self.pushNotification()
                } catch {
                    print(error)
                }
            }
        }
        
        testButton.addAction(action, for: .touchUpInside)
    }
    
    private func pushNotification() async throws {
        try await Main.main()
    }
    
    private func configureLayoutConstratint() {
        view.backgroundColor = .white
        
        view.addSubview(testTextView)
        view.addSubview(testButton)
        
        testTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testTextView.topAnchor.constraint(equalTo: view.topAnchor),
            testTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.85),
        ])
        
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.topAnchor.constraint(equalTo: testTextView.bottomAnchor),
            testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
    }
    
    func request() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let url = URL(string: "https://127.0.0.1:8080")!
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { data, response, error in
            print(data, response, error)
        }.resume()
    }
    
    func socket() {
        let webSocket = WebSocket.shared
        
        try? webSocket.openWebSocket()
        webSocket.delegate = self
        webSocket.onReceiveClosure = { (string, data) in
            print(string, data)
        }
        
        webSocket.send(message: "hello world")
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
