//
//  UserDetailCoordinator.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit
import Combine

class UserDetailCoordinator: Coordinator {
    private let finishSubject = PassthroughSubject<Void, Never>()
    var finished: AnyPublisher<Void, Never> {
          finishSubject.eraseToAnyPublisher()
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
        viewModel.backButtonTapped = { [weak self] in
            self?.navigationController.popViewController(animated: true)
            self?.finishSubject.send()
        }
        let vc = UserDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
