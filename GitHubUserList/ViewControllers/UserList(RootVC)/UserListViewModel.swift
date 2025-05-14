//
//  UserListViewModel.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Combine

class UserListViewModel {
    @Published private(set) var users: [GitHubUser] = []
    @Published private(set) var errorMessage: String?
    @Published var isLoading: Bool = false

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
                    self?.errorMessage = "Error: \(error)"
                }
            } receiveValue: { [weak self] newUsers in
                guard let self = self else { return }
                self.users.append(contentsOf: newUsers)
                self.since = newUsers.last?.id ?? self.since
                self.hasMoreData = !newUsers.isEmpty
            }
            .store(in: &cancellables)
    }

    func refreshUsers() {
        since = 0
        hasMoreData = true
        users = []
        fetchUsers()
    }
}
