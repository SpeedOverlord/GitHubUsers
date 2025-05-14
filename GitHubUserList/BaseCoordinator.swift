//
//  AppCoordinator.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit
class BaseCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // We don't have to use animation because this is the RootViewController.
    func start() {
        let userListCoordinator = UserListCoordinator(navigationController: navigationController)
        add(child: userListCoordinator)
        userListCoordinator.start()
    }
}
