//
//  SceneDelegate.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window)
        appCoordinator?.start()
        self.window = window
    }

}

