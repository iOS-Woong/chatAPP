//
//  SceneDelegate.swift
//  ChatStudyApp
//
//  Created by 서현웅 on 2023/08/01.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let friendListViewModel = FriendListViewModel()
        let viewController = FriendListViewController(viewModel: friendListViewModel)
        self.window = window

        window.rootViewController = viewController        
        window.makeKeyAndVisible()
    }
}

