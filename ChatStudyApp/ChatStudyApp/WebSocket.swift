//
//  WebSocket.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/23.
//

import Foundation

enum WebSocketError: Error {
    case invalidURL
}

final class WebSocket: NSObject {
    static let shared = WebSocket()
    
    private override init() {}
    
    var url: URL? = URL(string: "wss://127.0.0.1:8080/echo")
    var onReceiveClosure: ((String?, Data?) -> ())?
    weak var delegate: URLSessionWebSocketDelegate?
    
    
    private var webSocketTask: URLSessionWebSocketTask? {
        didSet { oldValue?.cancel(with: .goingAway, reason: nil) }
    }
    private var timer: Timer?
}

extension WebSocket {
    func openWebSocket() throws {
        guard let url = url else { throw WebSocketError.invalidURL }
        
        let urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        
        let webSocketTask = urlSession.webSocketTask(with: url)
        
        receiveStart()
        
        webSocketTask.resume()
        
        self.webSocketTask = webSocketTask
        
        self.startPing()
    }
    
    private func receiveStart() {
        webSocketTask?.receive { result in
            print("Closure")
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print("recieve Failed", failure)
            }
            self.receiveStart()
        }
    }
    
    private func startPing() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 5,
            repeats: true,
            block: { [weak self] _ in
            self?.ping()
        })
    }
    
    private func ping() {
        self.webSocketTask?.sendPing(pongReceiveHandler: { [weak self] error in
            guard let error = error else { return }
            print("Ping failed \(error)")
            self?.startPing()
        })
    }
    
    func send(message: String) {
        self.send(message: message, data: nil)
    }
    
    func send(data: Data) {
        self.send(message: nil, data: data)
    }
    
    private func send(message: String?, data: Data?) {
        let taskMessage: URLSessionWebSocketTask.Message
        if let string = message {
            taskMessage = URLSessionWebSocketTask.Message.string(string)
        } else if let data = data {
            taskMessage = URLSessionWebSocketTask.Message.data(data)
        } else {
            return
        }
        
        print("Send message \(taskMessage)")
        self.webSocketTask?.send(taskMessage, completionHandler: { error in
            guard let error = error else { return }
            print("WebSOcket sending error: \(error)")
        })
    }
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?)
        -> Void)
    {
        //accept all certs when testing, perform default handling otherwise
        completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        self.delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didOpenWithProtocol: `protocol`
        )
    }
    
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        self.delegate?.urlSession?(
            session,
            webSocketTask: webSocketTask,
            didCloseWith: closeCode,
            reason: reason
        )
    }
}
