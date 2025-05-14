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

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var blogLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var repoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setupViews()
    }

    private func setupViews() {
        self.addSubview(avatarImageView)
        self.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 20
        contentStackView.alignment = .leading
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
   
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
        ])

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
        nameLabel.text = String(localized: "name") + " \(detail.name ?? "-")"
        loginLabel.text = String(localized: "userName") + " \(detail.login)"
        companyLabel.text = String(localized: "company") + " \(detail.company ?? "-")"
        blogLabel.text = String(localized: "blog") + " \(detail.blog ?? "-")"
        locationLabel.text = String(localized: "location") + " \(detail.location ?? "-")"
        emailLabel.text = String(localized: "email") + " \(detail.email ?? "-")"
        bioLabel.text = String(localized: "bio") + " \(detail.bio ?? "-")"
        repoLabel.text = String(localized: "public_repos_count") + " \(detail.public_repos)"
        followersLabel.text = String(localized: "followers_count") + " \(detail.followers)"
        followingLabel.text = String(localized: "following_count") + " \(detail.following)"
    }
}
