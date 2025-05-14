//
//  UserDetailView.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

final class UserDetailView: UIView {

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let nameLabel = UILabel()
    private let loginLabel = UILabel()
    private let companyLabel = UILabel()
    private let blogLabel = UILabel()
    private let locationLabel = UILabel()
    private let emailLabel = UILabel()
    private let bioLabel = UILabel()
    private let repoLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupScrollView()
        setupStackView()
    }

    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupStackView() {
        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 12
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

        avatarImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        contentStackView.addArrangedSubview(avatarImageView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(loginLabel)
        contentStackView.addArrangedSubview(companyLabel)
        contentStackView.addArrangedSubview(blogLabel)
        contentStackView.addArrangedSubview(locationLabel)
        contentStackView.addArrangedSubview(emailLabel)
        contentStackView.addArrangedSubview(bioLabel)
        contentStackView.addArrangedSubview(repoLabel)
        contentStackView.addArrangedSubview(followersLabel)
        contentStackView.addArrangedSubview(followingLabel)
    }
}

extension UserDetailView: UserDetailPresentable {
    func configure(detail: GitHubUserDetail) {
        avatarImageView.image = detail.avatarImage
        nameLabel.text = "Name: \(detail.name ?? "-")"
        loginLabel.text = "Login: \(detail.login)"
        companyLabel.text = "Company: \(detail.company ?? "-")"
        blogLabel.text = "Blog: \(detail.blog ?? "-")"
        locationLabel.text = "Location: \(detail.location ?? "-")"
        emailLabel.text = "Email: \(detail.email ?? "-")"
        bioLabel.text = "Bio: \(detail.bio ?? "-")"
        repoLabel.text = "Public Repos: \(detail.public_repos)"
        followersLabel.text = "Followers: \(detail.followers)"
        followingLabel.text = "Following: \(detail.following)"
    }
}
