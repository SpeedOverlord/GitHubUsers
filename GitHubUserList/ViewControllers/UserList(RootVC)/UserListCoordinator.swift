//
//  UserListCoordinator.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit
import Combine

protocol UserListCoordinatorProtocol: AnyObject {
    func navigateToUserDetailPage(with username: String)
}

class UserListCoordinator: Coordinator {
    private var cancellables = Set<AnyCancellable>()
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // We don't have to use animation because this is the RootViewController.
    func start() {
        let viewModel = UserListViewModel(apiService: UserListAPIService())
        viewModel.onSelectUser = { [weak self] username in
            self?.navigateToUserDetailPage(with: username)
        }
        let vc = UserListViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
}

extension UserListCoordinator: UserListCoordinatorProtocol {
    func navigateToUserDetailPage(with username: String) {
        let userDetailCoordinator = UserDetailCoordinator(navigationController: navigationController, username: username)
        add(child: userDetailCoordinator)
        userDetailCoordinator.finished.sink { [weak self, weak userDetailCoordinator] in
            if let coordinator = userDetailCoordinator {
                self?.remove(child: coordinator)
            }
        }
        .store(in: &cancellables)
        userDetailCoordinator.start()
    }
}
