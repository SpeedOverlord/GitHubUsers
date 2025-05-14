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

class UserListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let viewModel: UserListViewModel
    var dataSource: UICollectionViewDiffableDataSource<UserListSection, UserListItem>?
    private var cancellables = Set<AnyCancellable>()

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
        setupCollectionView()
        configureDataSource()
        layoutView()
        bindViewModel()
        viewModel.fetchUsers()
    }
    
    private func setupBackgroundView() {
        view.backgroundColor = .backgroundColor
    }

    private func setupCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(view.frame.size.width), heightDimension: .estimated(50))
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
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                switch error {
                case .reachedRateLimit:
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                    })
                    self?.present(alert, animated: true)
                    
                default:
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
                        self?.viewModel.fetchUsers()
                    })
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

extension UserListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 {
            viewModel.fetchUsers()
        }
    }
}
