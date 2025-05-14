//
//  BaseViewController.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit
import ProgressHUD

class BaseViewController: UIViewController {
    var backButtonDidTapped: (() -> Void)?
    override func viewDidLoad() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.labelColor]
        appearance.backgroundColor = .backgroundColor

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

extension BaseViewController {
    func setupNavigationBarBackButton() {
        let backButton = UIBarButtonItem(
            title: String(localized: "back"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        backButtonDidTapped?()
    }
}

extension BaseViewController {
    func indicatorShow() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorAnimation = .systemBlue
        ProgressHUD.colorProgress = .systemBlue
        ProgressHUD.animate()
    }
    
    func indicatorHide() {
        ProgressHUD.dismiss()
        ProgressHUD.remove()
    }
}
