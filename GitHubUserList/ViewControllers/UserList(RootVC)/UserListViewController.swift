//
//  UserListViewController.swift
//  GitHubUserList
//
//  Created by Tim Chen on 2025/5/14.
//

import UIKit
import Combine

enum UserListSection: Hashable {
    case main
}

enum UserListItem: Hashable {
    case cell(GitHubUser)
}

class UserListViewController: BaseViewController {
    private var collectionView: UICollectionView!
    private let viewModel: UserListViewModel
    var dataSource: UICollectionViewDiffableDataSource<UserListSection, UserListItem>?
    private var cancellables = Set<AnyCancellable>()
    private var isFetching: Bool = false
    
    private lazy var userListRateLimitView: UserListRateLimitView = {
        let view = UserListRateLimitView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.onRetry = { [weak self] in
            self?.viewModel.fetchUsers()
        }
        return view
    }()

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupTitle()
        setupSubviews()
        setupCollectionView()
        configureDataSource()
        layoutView()
        bindViewModel()
        viewModel.fetchUsers()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .backgroundColor
    }
    
    private func setupTitle() {
        title = String(localized: "gitHub_user_list")
    }
    
    private func setupSubviews() {
        view.addSubview(userListRateLimitView)
        
        NSLayoutConstraint.activate([
            userListRateLimitView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userListRateLimitView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userListRateLimitView.widthAnchor.constraint(equalTo: view.widthAnchor),
            userListRateLimitView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    private func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
             
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UserGeneralCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
    }
    
    func configureDataSource() {
          dataSource = UICollectionViewDiffableDataSource<UserListSection, UserListItem>(collectionView: collectionView) { (collectionView, indexPath, user) -> UICollectionViewCell? in
              guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UserCellable else {
                  return nil
              }
              switch user {
              case .cell(let u):
                  cell.configure(user: u)
              }
              return cell
          }
      }
    
    private func layoutView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func bindViewModel() {
        viewModel.$users
            .receive(on: DispatchQueue.main)
            .sink { [weak self] users in
                var snapshot = NSDiffableDataSourceSnapshot<UserListSection, UserListItem>()
                snapshot.appendSections([.main])
                snapshot.appendItems(users.map { .cell($0) }, toSection: .main)
                self?.dataSource?.apply(snapshot, animatingDifferences: true) { [weak self] in
                    self?.isFetching = false
                }
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                guard let self = self else { return }
                switch error {
                case .reachedRateLimit(let response):
                    let itemCount = self.collectionView.numberOfItems(inSection: 0)
                    if itemCount == 0 {
                        self.userListRateLimitView.isHidden = false
                        self.view.bringSubviewToFront(self.userListRateLimitView)
                    } else {
                        self.userListRateLimitView.isHidden = true
                    }
                    if self.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error", message: response.message, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        })
                        self.present(alert, animated: true)
                    }
                default:
                    if self.presentedViewController == nil {
                        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self]_ in
                            self?.viewModel.fetchUsers()
                        })
                        self.present(alert, animated: true)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectUser(at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isFetching else { return }
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        // 觸發條件為幾乎滑到底部時
        let threshold: CGFloat = 150 // 緩衝距離
        let isNearBottom = offsetY + height >= contentHeight - threshold
        
        if isNearBottom {
            self.isFetching = true
            viewModel.fetchUsers()
        }
    }
}
