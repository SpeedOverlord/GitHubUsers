//
//  UserDetailViewModel.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Foundation
import Combine
import SDWebImage

enum UserDetailState {
    case idle
    case loading
    case success(GitHubUserDetail)
    case failure(UserDetailAPIError)
}

class UserDetailViewModel {
    private let username: String
    private let apiService: UserDetailAPIServiceProtocol
    
    @Published private(set) var state: UserDetailState = .idle

    private var cancellables = Set<AnyCancellable>()
    
    var backButtonTapped: (() -> Void)?

    init(username: String, apiService: UserDetailAPIServiceProtocol) {
        self.username = username
        self.apiService = apiService
    }
}

//MARK: - API handling
extension UserDetailViewModel {
    func fetchDetail() {
        self.state = .loading
        apiService.fetchUserDetail(username: username)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.state = .failure(error)
                }
            } receiveValue: { [weak self] detail in
                guard let self = self else { return }

                self.downloadImage(for: detail)
            }
            .store(in: &cancellables)
    }
    
    private func downloadImage(for userDetail: GitHubUserDetail) {
        var modifiedUserDetail = userDetail
        let group = DispatchGroup()
        guard let url = URL(string: userDetail.avatar_url) else { return }
        group.enter()
        SDWebImageManager.shared.loadImage(with: url, options: .highPriority, progress: nil) { [weak self] image, _, error, _, _, _ in
            guard let self = self else { return }
            if let _ = error {
                modifiedUserDetail.avatarImage = UIImage(systemName: "person.fill")
            } else if let image = image {
                modifiedUserDetail.avatarImage = image
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.state = .success(modifiedUserDetail)
        }
    }
}

extension UserDetailViewModel {
    func backButtonDidTap() {
        backButtonTapped?()
    }
}
