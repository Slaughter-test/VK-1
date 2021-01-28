//
//  FriendsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    let networkService = NetworkService()
    private var friendList = [Friend]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
        networkService.loadFriendList { [weak self] friends in
            self?.loadData()
            self?.tableView.reloadData()

        }

        setupViews()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return friendList.count } else {
                return searchedFriends.count
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        if searching == false {
            cell.friend = friendList[indexPath.row] } else { cell.friend = searchedFriends[indexPath.row] }
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
    
    
    
    
    // MARK: - variables
    var searching = false
    var searchedFriends: Array<Friend> = []
    //MARK: - Elements
    let searchBar = UISearchBar()
    var addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))

    private func setupViews() {
        self.addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        self.tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Friends"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        self.navigationItem.rightBarButtonItem  = addFriendButton
        self.navigationItem.titleView = searchBar
    }
    
    @objc func addFriend() {
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    func loadData() {
        do {
                   let realm = try Realm()
                   
                   let friends = realm.objects(Friend.self).sorted(byKeyPath: "lastName")
                   
                   self.friendList = Array(friends)
                   
               } catch {
       // если произошла ошибка, выводим ее в консоль
                   print(error)
               }

    }
}
extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedFriends.removeAll()
        self.tableView.reloadData()
        if searchText != "" {
        for i in friendList {
            if i.lastName.contains(searchText) {
                searchedFriends.append(i)
            }
        }
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
