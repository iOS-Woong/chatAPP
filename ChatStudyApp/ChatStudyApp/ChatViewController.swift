//
//  ChatViewController.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/09.
//

import UIKit

class ChatViewController: UIViewController {

    private let testTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayoutConstratint()
        testTextView.text = "이건첫번째메시지"
        
        MockSocket().requestPost()
        
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
}
