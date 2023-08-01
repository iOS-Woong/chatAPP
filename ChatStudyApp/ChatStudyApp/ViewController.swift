//
//  ViewController.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/01.
//
// key정보
// Subject: C=KR, ST=Seoul, L=Gumi, O=Wetudy, OU=StudyChat, CN=studychat.com/emailAddress=workplayhard1@naver.com

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        requestTest()
    }

    func requestTest() {
        let urlString = "https://studychat.com"
        let url = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            print(data)
            print(response)
            print(error)
        }
        task.resume()
    }
}

