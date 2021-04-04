//
//  ListViewController.swift
//  ChatApp
//
//  Created by Tsibulko on 17.03.2021.
//

import UIKit
import FirebaseFirestore


class ListViewController: UIViewController {
    
    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        
        func description() -> String {
            switch self  {
            case .waitingChats:
                return "Waiting chats"
            case .activeChats:
                return "Active chats"
            }
        }
    } // end of enum Section
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    var collectionView: UICollectionView!
    
    private let currentUser: MUser
    
    init(currentUser: MUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        
        createDataSource()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { (result) in
            switch result {
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true, completion: nil)
                }
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Oops", and: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { (result) in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Oops", and: error.localizedDescription)
            }
        })
        
    } // end of override func viewDidLoad()
    
    
    private func setupSearchBar() {
        
        navigationController?.navigationBar.barTintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    } // end of private func setupSearchBar()
    
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
        
    } // private func setupCollectionView()
    
    
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        snapshot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    } // end of private func reloadData()
    
} // end of class ListViewController


// MARK: - Data Source

extension ListViewController {
    
    private func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
        
        dataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader
            else {
                fatalError("Can't create new section header")
            }
            
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section kind")}
            
            sectionHeader.configure(text: section.description(), font: .laoSangamMN20(), textColor: #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1))
            
            return sectionHeader
        }
        
    } // end of private func createDataSource()
    
} // end of extension ListViewController



// MARK: - Setup Compositional Layout

extension ListViewController {

    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section kind")
            }
            
            switch section {
            case .activeChats:
                return self?.createActiveChats()
            case .waitingChats:
                return self?.createWaitingChats()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        
        return layout
        
    } // end of private func createCompositionalLayout()
    
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        section.orthogonalScrollingBehavior = .continuous
        
        section.boundarySupplementaryItems = [createSectionHeader()]
       
        return section
    }
    
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        section.boundarySupplementaryItems = [createSectionHeader()]
        
        return section
    }
    
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
         
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
    
} // end of extension ListViewController


// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let chat = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true, completion: nil)
            
        case .activeChats:
            let chatsVC = ChatsViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatsVC, animated: true)
        }
        
    } // end of func collectionView(_ collectionView: UICollectionView, didSelectItemAt ...
    
} // end of extension ListViewController: UICollectionViewDelegate


// MARK: - UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // TODO: - Searching through chats
    }
    
} // end of extension ListViewController: UISearchBarDelegate


// MARK: - WaitingChatsNavigation

extension ListViewController: WaitingChatsNavigation {
    
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { (result) in
            switch result {
            case .success():
                self.showAlert(with: "Congratulations!", and: "Chat with \(chat.friendUsername) was deleted")
            case .failure(let error):
                self.showAlert(with: "Oops", and: error.localizedDescription)
            }
        }
    } // end of func removeWaitingChat
    
    func changeToActive(chat: MChat) {
        FirestoreService.shared.changeToActive(chat: chat) { (result) in
            switch result {
            case .success():
                self.showAlert(with: "Congratulations!", and: "Have a nice chat with \(chat.friendUsername).")
            case .failure(let error):
                self.showAlert(with: "Oops", and: error.localizedDescription)
            }
        }
    } // end of func changeToActive
    
} // end of extension ListViewController: WaitingChatsNavigation




