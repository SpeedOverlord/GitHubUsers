//
//  Coordinator.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(child coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }

    func remove(child coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
