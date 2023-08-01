//
//  ViewController.swift
//  chatAPP
//
//  Created by 서현웅 on 2023/07/26.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
    }
    // https://127.0.0.1:8080/
    func request() {
        let url = URL(string: "https://chat.com")!
        let urlRequest = URLRequest(url: url)
        
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            print("data:::", data)
            print("response:::", response)
            print("error:::", error)
        }
        task.resume()
    }
}

extension ViewController: URLSessionDelegate {
  func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

    //accept all certs when testing, perform default handling otherwise
    completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
  }
}
