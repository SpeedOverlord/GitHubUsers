//
//  GitHubUser.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

struct GitHubUser: Codable, Hashable {
    let id: Int
    let login: String
    let avatar_url: String
    let site_admin: Bool
    var avatarImage: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatar_url
        case site_admin
    }
}
