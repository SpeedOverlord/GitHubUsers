//
//  UserDetailAPIServiceProtocol.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Combine

protocol UserDetailAPIServiceProtocol {
    func fetchUserDetail(username: String) -> AnyPublisher<GitHubUserDetail, UserDetailAPIError>
}
