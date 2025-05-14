//
//  UserDetailCoordinator.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

class UserDetailCoordinator: Coordinator {
    deinit {
        print("UserDetailCoordinator deinit")
    }
    
    var childCoordinators = [Coordinator]()
    
    var userName: String
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, userName: String) {
        self.navigationController = navigationController
        self.userName = userName
    }

    // We don't have to use animation because this is the RootViewController.
    func start() {
        let viewModel = UserDetailViewModel(userName: userName, apiService: UserDetailAPIService())
        let vc = UserDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
