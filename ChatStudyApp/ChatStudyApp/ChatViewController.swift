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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutConstratint()
        testTextView.text = "default"
        socket()
    }
    
    private func configureLayoutConstratint() {
        view.addSubview(testTextView)
        
        testTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testTextView.topAnchor.constraint(equalTo: view.topAnchor),
            testTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
