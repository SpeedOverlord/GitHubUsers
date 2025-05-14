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
    case unknownStatusCode(Int)
    case reachedRateLimit(GitHubAPIErrorResponse)
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
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UserListAPIError.networkError(URLError(.badServerResponse))
                }

                if (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    // 嘗試解碼 GitHub API 的錯誤格式
                    if let apiError = try? JSONDecoder().decode(GitHubAPIErrorResponse.self, from: data) {
                        throw UserListAPIError.reachedRateLimit(apiError)
                    } else {
                        throw UserListAPIError.unknownStatusCode(httpResponse.statusCode)
                    }
                }
            }
            .decode(type: [GitHubUser].self, decoder: JSONDecoder())
            .mapError { error -> UserListAPIError in
                if let appError = error as? UserListAPIError {
                    return appError
                } else if let decodingError = error as? DecodingError {
                    return .decodingError(decodingError)
                } else {
                    return .networkError(error)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
