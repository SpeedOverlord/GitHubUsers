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
    case reachedRateLimit(GitHubUserListAPIErrorResponse)
}


final class UserListAPIService: UserListAPIServiceProtocol {
    private let baseURL = "https://api.github.com/users"
    private let perPage = 20

    func fetchUsers(since: Int) -> AnyPublisher<[GitHubUser], UserListAPIError> {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "since", value: "\(since)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UserListAPIError.networkError(URLError(.badServerResponse))
                }
                
                switch httpResponse.statusCode {
                case 200:
                    return data
                case 403:
                    if let apiError = try? JSONDecoder().decode(GitHubUserListAPIErrorResponse.self, from: data) {
                        throw UserListAPIError.reachedRateLimit(apiError)
                    } else {
                        throw UserDetailAPIError.unknown
                    }
                default:
                    throw UserDetailAPIError.unknown
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
