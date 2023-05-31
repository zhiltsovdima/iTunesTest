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

protocol AppCoordinatorProtocol: AnyObject {
    func showDetail(with songModel: SongModel)
}

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private let networkManager = NetworkManager()
    lazy private var musicService = MusicService(networkManager)
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = MainViewModel(self, musicService)
        let controller = MainViewController(viewModel: viewModel)
        navigationController.setViewControllers([controller], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AppCoordinatorProtocol {
    
    func showDetail(with songModel: SongModel) {
        let viewModel = DetailViewModel(self, musicService, songModel)
        let controller = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }

}
