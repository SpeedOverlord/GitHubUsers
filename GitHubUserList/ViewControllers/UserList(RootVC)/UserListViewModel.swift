//
//  UserListViewModel.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Combine
import SDWebImage

class UserListViewModel {
    @Published private(set) var users: [GitHubUser] = []
    @Published private(set) var error: UserListAPIError?
    @Published var isLoading: Bool = false

    private var userImages: [Int: UIImage] = [:]
    private let apiService: UserListAPIService
    private var cancellables = Set<AnyCancellable>()
    private var since: Int = 0
    private var isFetching: Bool = false
    private var hasMoreData: Bool = true

    init(apiService: UserListAPIService) {
        self.apiService = apiService
    }

    func fetchUsers() {
        guard !isFetching && hasMoreData else { return }
        isFetching = true
        isLoading = true
        apiService.fetchUsers(since: since)
            .sink { [weak self] completion in
                self?.isFetching = false
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] newUsers in
                guard let self = self else { return }

                let combinedUsers = self.users + newUsers

                self.downloadImages(combinedUsers: combinedUsers, for: newUsers)
                self.since = newUsers.last?.id ?? self.since
                self.hasMoreData = !newUsers.isEmpty
            }
            .store(in: &cancellables)
    }

    private func downloadImages(combinedUsers: [GitHubUser] , for users: [GitHubUser]) {
        var combinedUsers = combinedUsers
        let group = DispatchGroup()
        for (index, user) in users.enumerated() {
            guard let url = URL(string: user.avatar_url) else { return }
            group.enter()
            SDWebImageManager.shared.loadImage(with: url, options: .highPriority, progress: nil) { [weak self] image, _, error, _, _, _ in
                guard let self = self else { return }
                if let _ = error {
                    combinedUsers[self.users.count + index].avatarImage = UIImage(systemName: "person.fill")
                    self.updateUserListWithImages()
                } else if let image = image {
                    combinedUsers[self.users.count + index].avatarImage = image
                    self.updateUserListWithImages()
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.users = combinedUsers
        }
    }

    private func updateUserListWithImages() {
        for (index, user) in users.enumerated() {
            if let image = userImages[user.id] {
                users[index].avatarImage = image
            }
        }
    }
}

