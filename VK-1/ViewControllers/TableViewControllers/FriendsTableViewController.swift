//
//  FriendsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit
import RealmSwift
import Alamofire

class FriendsTableViewController: UITableViewController {
    
    private let friendsService = FriendsNetworkAdapter()
    private let networkService = NetworkService()
    private let viewModelFactory = FriendsViewModelFactory()
    private var viewModels: [FriendViewModel] = []
    
    let photoService: PhotoService = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.photoService ?? PhotoService()
    }()
    
    var friendList: [Friend] = []
    var searching = false
    var searchedFriends: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        

        setupViews()
        updateData()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        

        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        self.tableView.refreshControl = refreshControl
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return viewModels.count } else {
                return searchedFriends.count
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        if searching == false {
            cell.configure(with: viewModels[indexPath.row], photoService: photoService)
        } else { cell.friend = searchedFriends[indexPath.row] }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PhotoCollectionViewController1") as! PhotoCollectionViewController
        if searching == false {
            vc.id = friendList[indexPath.row].id } else {
                vc.id = searchedFriends[indexPath.row].id
            }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                showDeleteFriend(indexPath: indexPath)
            }
        }
    
    //MARK: - Elements
    let searchBar = UISearchBar()
    var addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))

    private func setupViews() {
        self.addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        self.tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Friends"
        self.navigationController?.navigationBar.barTintColor = .brandPurple
        self.navigationItem.rightBarButtonItem  = addFriendButton
        self.navigationItem.titleView = searchBar
    }
    @objc
    private func updateData() {
        friendsService.getFriends { [self] friends in
            self.friendList = friends
            self.viewModels = self.viewModelFactory.constructViewModels(from: friendList)
        }
        if refreshControl?.isRefreshing == true {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func showDeleteFriend(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Удалить из друзей?", message: "Вы действительно хотите удалить \(friendList[indexPath.row].firstName)" +  " " + "\(friendList[indexPath.row].lastName)" + " " + "из друзей?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            friendsService.deleteFriend(friend: friendList[indexPath.row])
            friendList.remove(at: indexPath.row)
            self.tableView.reloadData()
        })
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: {_ in
            self.tableView.reloadData()
        })
            alert.addAction(action)
            alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func addFriend() {
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    
}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
        var search: [Friend] = []
        if searchText != "" {
            for friends in friendList {
                if friends.lastName.contains(searchText) {
                    search.append(friends)
                }
            }
            searchedFriends = search

        } else { searchedFriends = friendList }
        searching = true
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(self.searchBarCancelButtonClicked(_:)))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        self.searchBar.text = ""
        self.tableView.reloadData()
        self.searchBar.endEditing(false)
        self.navigationItem.rightBarButtonItem  = self.addFriendButton
    }
}
