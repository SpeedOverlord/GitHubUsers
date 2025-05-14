//
//  UserGeneralCell.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit

class UserGeneralCell: UICollectionViewCell {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    fileprivate lazy var loginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.text = String(localized: "userName")
        return label
    }()
    
    fileprivate lazy var loginNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    fileprivate lazy var siteAdminTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.text = String(localized: "is_superuser")
        return label
    }()
    
    fileprivate lazy var siteAdminStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(loginTitleLabel)
        contentView.addSubview(loginNameLabel)
        contentView.addSubview(siteAdminTitleLabel)
        contentView.addSubview(siteAdminStatusLabel)


        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
            loginTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            loginTitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            
            loginNameLabel.topAnchor.constraint(equalTo: loginTitleLabel.topAnchor),
            loginNameLabel.leadingAnchor.constraint(equalTo: loginTitleLabel.trailingAnchor, constant: 5),
            loginNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            siteAdminTitleLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 10),
            siteAdminTitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),

            siteAdminStatusLabel.topAnchor.constraint(equalTo: siteAdminTitleLabel.topAnchor),
            siteAdminStatusLabel.leadingAnchor.constraint(equalTo: siteAdminTitleLabel.trailingAnchor, constant: 5),            siteAdminStatusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UserGeneralCell: UserCellable {
    func configure(user data: GitHubUser) {
        imageView.image = data.avatarImage
        loginNameLabel.text = data.login
        siteAdminStatusLabel.text = data.site_admin ? String(localized: "yes") : String(localized: "no")
    }
}
