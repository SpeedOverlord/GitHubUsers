//
//  GitHubUserListTests.swift
//  GitHubUserListTests
//
//  Created by Tim Chen on 2025/5/14.
//

import XCTest
@testable import GitHubUserList
import Combine

final class GitHubUserAPITests: XCTestCase {
    
    func testFetchUserListReturnsSuccess() {
        let expectation = self.expectation(description: "Fetch user list should succeed")
        var cancellables = Set<AnyCancellable>()
        
        UserListAPIService().fetchUsers(since: 0)
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("API Error: \(error)")
                    expectation.fulfill()
                }
            } receiveValue: { _ in
                XCTAssertTrue(true)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchUserDetailReturnsSuccess() {
        let expectation = self.expectation(description: "Fetch user list should succeed")
        var cancellables = Set<AnyCancellable>()
        
        UserDetailAPIService().fetchUserDetail(username: "SpeedOverlord")
            .sink { completion in
                if case let .failure(error) = completion {
                    XCTFail("API Error: \(error)")
                    expectation.fulfill()
                }
            } receiveValue: { detail in
                XCTAssertTrue(true)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 5.0)
    }
    
}
