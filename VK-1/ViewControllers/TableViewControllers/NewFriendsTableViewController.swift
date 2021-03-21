//
//  NewFriendsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 04.01.2021.
//

import UIKit

class NewFriendsTableViewController: UITableViewController {
    
    let networkService = NetworkService()
    private var friendList = [Friend]()
    
    let photoService: PhotoService = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.photoService ?? PhotoService()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        networkService.loadSuggestedFriends { [weak self] friends in
            self?.friendList = friends
            self?.tableView.reloadData()

        }
        
        setupViews()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        cell.configure(with: friendList[indexPath.row], photoService: photoService)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAddFriend(indexPath: indexPath)
    }
    private func setupViews() {

        self.tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Friends"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)

    }
    
    func convertFriend(indexPath: IndexPath) {
        friendList.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    private func showAddFriend(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Добавить в друзья", message: "Вы действительно хотите добавить \(friendList[indexPath.row].firstName)" +  " " + "\(friendList[indexPath.row].lastName)" + " " + "в друзья?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            self.networkService.addFriend(id: friendList[indexPath.row].id)
            self.convertFriend( indexPath: indexPath)
        })
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: {_ in
            self.tableView.reloadData()
        })
            alert.addAction(action)
            alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
}
