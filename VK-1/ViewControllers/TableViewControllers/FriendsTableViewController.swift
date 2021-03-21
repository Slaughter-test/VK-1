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
    
    let networkService = NetworkService()
    let operationQueue = OperationQueue()
    
    var friendList = try? Realm().objects(Friend.self).sorted(byKeyPath: "lastName")
    
    
    let url = "https://api.vk.com/method/friends.get"
    let parameters: Parameters = [
        "user_id": Session.instance.userId,
        "access_token": Session.instance.token,
        "v": "5.68",
        "fields": "city, domain, photo",
        "order": "name"
    ]
    

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
        self.token?.invalidate()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return friendList?.count ?? 0} else {
                return searchedFriends?.count ?? 0
            }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        if searching == false {
            cell.friend = friendList?[indexPath.row] } else { cell.friend = searchedFriends?[indexPath.row] }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PhotoCollectionViewController1") as! PhotoCollectionViewController
        if searching == false {
            vc.id = friendList?[indexPath.row].id ?? 0} else {
                vc.id = searchedFriends?[indexPath.row].id ?? 0
            }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                showDeleteFriend(indexPath: indexPath)
            }
        }

    
    
    
    
    // MARK: - variables
    var searching = false
    var searchedFriends: Results<Friend>?
    var token: NotificationToken?
    
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
    @objc
    private func updateData() {
        let request = Alamofire.request(url,
                                 method: .get,
                                 parameters: parameters)
        
        let rp = RequestOperation(request: request)
        let parseOp = ParseDataOperation()
        parseOp.addDependency(rp)
        let realmOp = RealmOperations()
        realmOp.addDependency(parseOp)
        operationQueue.addOperations([rp, parseOp, realmOp], waitUntilFinished: false)
        friendList = try? Realm().objects(Friend.self).sorted(byKeyPath: "lastName")
        if refreshControl?.isRefreshing == true {
            self.refreshControl?.endRefreshing()
        }
    }
    
    private func showDeleteFriend(indexPath: IndexPath) {
        let friend = friendList![indexPath.row]
        let alert = UIAlertController(title: "Удалить из друзей?", message: "Вы действительно хотите удалить \(friendList![indexPath.row].firstName)" +  " " + "\(friendList![indexPath.row].lastName)" + " " + "из друзей?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            self.networkService.deleteFriend(id: friendList![indexPath.row].id)
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(friend)
                try realm.commitWrite()
            } catch {
                print(error)
            }
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
    
    func realmObserver() {
        self.token = friendList?.observe {  (changes: RealmCollectionChange) in
                    switch changes {
                    case .initial( _):
                        self.tableView.reloadData()
                    case .update(_, let deletions, let insertions, let modifications):
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                                         with: .automatic)
                        self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                                         with: .automatic)
                        self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                                         with: .automatic)
                        self.tableView.endUpdates()
                    case .error(let error):
                        print(error)
                    }
                    print("данные изменились")
                }


    }
    
    
}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.tableView.reloadData()
        if searchText != "" {
            searchedFriends = friendList!.filter("lastName contains '\(searchText)'")
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
