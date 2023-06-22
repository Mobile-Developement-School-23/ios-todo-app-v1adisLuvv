//
//  SceneDelegate.swift
//  TodoList
//
//  Created by Vlad Boguzh on 2023-06-17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DetailViewController()
        window?.makeKeyAndVisible()
    }
}

