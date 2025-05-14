//
//  UserCellable.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

protocol UserCellable: UICollectionViewCell {
    func configure(user data: GitHubUser)
}
