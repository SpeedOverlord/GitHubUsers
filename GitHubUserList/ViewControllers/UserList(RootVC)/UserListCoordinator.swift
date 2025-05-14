//
//  UserListCoordinator.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

protocol UserListCoordinatorProtocol: AnyObject {
    func navigateToUserDetailPage(with userName: String)
}

class UserListCoordinator: Coordinator {
    deinit {
        print("UserListCoordinator deinit")
    }
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // We don't have to use animation because this is the RootViewController.
    func start() {
        let viewModel = UserListViewModel(apiService: UserListAPIService())
        viewModel.onSelectUser = { [weak self] userName in
            self?.navigateToUserDetailPage(with: userName)
        }
        let vc = UserListViewController(viewModel: viewModel)
        vc.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(vc, animated: false)
    }
}

extension UserListCoordinator: UserListCoordinatorProtocol {
    func navigateToUserDetailPage(with userName: String) {
        let userDetailCoordinator = UserDetailCoordinator(navigationController: navigationController, userName: userName)
        add(child: userDetailCoordinator)
        userDetailCoordinator.start()
    }
}
