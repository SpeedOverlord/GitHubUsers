//
//  UserDetailPresentable.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

protocol UserDetailPresentable: UIView {
    func configure(detail: GitHubUserDetail)
}
