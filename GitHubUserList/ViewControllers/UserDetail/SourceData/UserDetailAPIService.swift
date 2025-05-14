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
    case unknown
    case notModified
    case notFound
}

final class UserDetailAPIService: UserDetailAPIServiceProtocol  {
    private lazy var configuration: URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,
            diskCapacity: 50 * 1024 * 1024,
            diskPath: "github_api_detail_cache"
        )
        return configuration
    }()

    
    private lazy var session: URLSession = {
        URLSession(configuration: configuration)
    }()

    func fetchUserDetail(username: String) -> AnyPublisher<GitHubUserDetail, UserDetailAPIError> {
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else {
            return Fail(error: .unknown).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadRevalidatingCacheData
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            do {
                let decoded = try JSONDecoder().decode(GitHubUserDetail.self, from: cachedResponse.data)
                return Just(decoded)
                    .setFailureType(to: UserDetailAPIError.self)
                    .eraseToAnyPublisher()
            } catch {}
        }

    
        request.cachePolicy = .reloadIgnoringLocalCacheData
        // 加入 If-None-Match
        if let etag = ETagCache.shared.etag(for: urlString) {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw UserDetailAPIError.networkError(URLError(.badServerResponse))
                }

                switch httpResponse.statusCode {
                case 200:
                    if let etag = httpResponse.value(forHTTPHeaderField: "ETag") {
                        ETagCache.shared.store(etag: etag, data: data, for: urlString)
                    }
                    return data

                case 304:
                    if let cachedData = ETagCache.shared.data(for: urlString) {
                        return cachedData
                    } else {
                        ETagCache.shared.deleteData(for: urlString)
                        throw UserDetailAPIError.notModified
                       
                    }
                    
                case 403:
                    if let apiError = try? JSONDecoder().decode(GitHubUserListAPIErrorResponse.self, from: data) {
                        throw UserListAPIError.reachedRateLimit(apiError)
                    } else {
                        throw UserDetailAPIError.unknown
                    }
                case 404:
                    throw UserDetailAPIError.notFound
                default:
                    throw UserDetailAPIError.unknown
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
            .eraseToAnyPublisher()
    }
}
