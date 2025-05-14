//
//  UserDetailAPIService.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//


import Foundation
import Combine

enum UserDetailAPIError: Error {
    case reachedRateLimit(GitHubUserDetailAPIErrorResponse)
    case unknownStatusCode(Int)
    case decodingError(DecodingError)
    case networkError(Error)
}

final class UserDetailAPIService: UserDetailAPIServiceProtocol {
    func fetchUserDetail(userName: String) -> AnyPublisher<GitHubUserDetail, UserDetailAPIError> {
        let url = URL(string: "https://api.github.com/users/\(userName)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UserDetailAPIError.networkError(URLError(.badServerResponse))
                }
                
                if (200..<300).contains(httpResponse.statusCode) {
                    return data
                } else {
                    // 嘗試解析 API 錯誤訊息
                    if let apiError = try? JSONDecoder().decode(GitHubUserDetailAPIErrorResponse.self, from: data) {
                        throw UserDetailAPIError.reachedRateLimit(apiError)
                    } else {
                        throw UserDetailAPIError.unknownStatusCode(httpResponse.statusCode)
                    }
                }
            }
            .decode(type: GitHubUserDetail.self, decoder: JSONDecoder())
            .mapError { error -> UserDetailAPIError in
                if let apiError = error as? UserDetailAPIError {
                    return apiError
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
