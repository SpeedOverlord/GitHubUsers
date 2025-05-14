//
//  UserDetailViewController.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit
import Combine

class UserDetailViewController: BaseViewController {

    private let viewModel: UserDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var userDetailView: UserDetailView = {
        let view = UserDetailView()
        view.blogDidTap = { url in
            UIApplication.shared.open(url)
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userDetailErrorView: UserDetailErrorView = {
        let view = UserDetailErrorView()
        view.onRetry = { [weak self] in
            self?.viewModel.fetchDetail()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarBackButton()
        backButtonDidTapped = { [weak self] in
            self?.viewModel.backButtonDidTap()
        }
        setupBackgroundView()
        setupSubviews()
        bindViewModel()
        viewModel.fetchDetail()
    }

    private func setupBackgroundView() {
        view.backgroundColor = .backgroundColor
    }
    
    private func setupSubviews() {
        view.addSubview(userDetailErrorView)
        view.addSubview(userDetailView)
        
        NSLayoutConstraint.activate([
            userDetailErrorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userDetailErrorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userDetailErrorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            userDetailErrorView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            userDetailView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userDetailView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userDetailView.widthAnchor.constraint(equalTo: view.widthAnchor),
            userDetailView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading, .idle:
                    self.indicatorShow()
                    break
                case .failure(let error):
                    self.indicatorHide()
                    var message: String = ""
                    switch error {
                    case .reachedRateLimit(_):
                        message = String(localized: "temporarily_unavailable")
                    default:
                        message = String(localized: "unknown_error")
                    }
                    self.userDetailErrorView.message = message
                    self.userDetailErrorView.isHidden = false
                    self.view.bringSubviewToFront(self.userDetailErrorView)
                case .success(let detail):
                    self.indicatorHide()
                    self.view.bringSubviewToFront(self.userDetailView)
                    self.userDetailView.configure(detail: detail)
                }
            }
            .store(in: &cancellables)
    }
}
