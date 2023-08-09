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

    private let testTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewAttributes()
        configureLayoutConstratint()
    }
    
    private func setupTableViewAttributes() {
        testTableView.dataSource = self
        testTableView.delegate = self
    }
    
    private func configureLayoutConstratint() {
        view.addSubview(testTableView)
        testTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            testTableView.topAnchor.constraint(equalTo: view.topAnchor),
            testTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "woong"
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = ChatViewController()
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
