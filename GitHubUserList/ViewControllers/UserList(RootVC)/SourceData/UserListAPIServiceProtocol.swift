//
//  UserListAPIServiceProtocol.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Combine

protocol UserListAPIServiceProtocol {
    func fetchUsers(since: Int) -> AnyPublisher<[GitHubUser], UserListAPIError>
}
