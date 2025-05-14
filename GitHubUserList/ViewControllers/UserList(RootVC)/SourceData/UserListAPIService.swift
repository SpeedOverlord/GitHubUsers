//
//  UserListAPIService.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import Combine
import Foundation

enum UserListAPIError: Error {
    case networkError(Error)
    case decodingError(Error)
}

class UserListAPIService {
    private let baseURL = "https://api.github.com/users"
    private let perPage = 20

    func fetchUsers(since: Int) -> AnyPublisher<[GitHubUser], UserListAPIError> {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "since", value: "\(since)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]

        var request = URLRequest(url: components.url!)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { .networkError($0) }
            .flatMap { data, _ in
                Just(data)
                    .decode(type: [GitHubUser].self, decoder: JSONDecoder())
                    .mapError { .decodingError($0) }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
