//
//  AppCoordinator.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let controller = UIViewController()
        navigationController.setViewControllers([controller], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
