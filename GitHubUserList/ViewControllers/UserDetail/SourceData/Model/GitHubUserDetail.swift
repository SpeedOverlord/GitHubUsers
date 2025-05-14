//
//  GitHubUserDetail.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

struct GitHubUserDetail: Decodable, Hashable {
    let login: String
    let id: Int
    let avatar_url: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?
    let public_repos: Int
    let followers: Int
    let following: Int
    var avatarImage: UIImage?
    
    enum CodingKeys: CodingKey {
        case login
        case id
        case avatar_url
        case name
        case company
        case blog
        case location
        case email
        case bio
        case public_repos
        case followers
        case following
    }
}
