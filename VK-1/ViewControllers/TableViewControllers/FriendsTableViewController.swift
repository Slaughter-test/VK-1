//
//  FriendsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit

class FriendsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self


        setupViews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searching == true { return 1 } else { return keys.count }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searching == false { return String(keys[section]) } else { return "Search result" }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false { sortFriendsToSection(title: keys[section])
            return sortedFriends.count
        } else { return searchedFriends.count }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        if searching == false {
            let key = keys[indexPath.section]
            sortFriendsToSection(title: key)
            cell.friend = sortedFriends[indexPath.row] } else { cell.friend = searchedFriends[indexPath.row] }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            friends.remove(at: indexPath.row)
            createKeys()
            self.tableView.reloadData()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPhotos", sender: self)
    }
    
    
    
    // MARK: - variables
    var keys = [Character]()
    var sortedFriends: Array<Friend> = []
    var searching = false
    var searchedFriends: Array<Friend> = []
    var friends: Array<Friend> = {
        let fr1 = Friend()
        let fr2 = Friend()
        let fr3 = Friend()
        let fr4 = Friend()
        let fr5 = Friend()
        let fr6 = Friend()
        let fr7 = Friend()
        let fr8 = Friend()
        let fr9 = Friend()
        fr1.firstName = "John"
        fr1.lastName = "Kramer"
        fr2.firstName = "Clown"
        fr2.lastName = "Pennywise"
        fr3.firstName = "Freddie"
        fr3.lastName = "Kruger"
        fr4.firstName = "Samara"
        fr4.lastName = "Morgan"
        fr5.firstName = "Alessa"
        fr5.lastName = "Gillespi"
        fr6.firstName = "Michael"
        fr6.lastName = "Myers"
        fr7.firstName = "Dr."
        fr7.lastName = "Salazar"
        fr8.firstName = "Damien"
        fr8.lastName = "Thorn"
        fr9.firstName = "Parker"
        fr9.lastName = "Kreyn"
        fr1.photos = [UIImage](arrayLiteral: UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!, UIImage(named: "4")!, UIImage(named: "5")!)
        fr1.photo = UIImage(named: "kramer")
        fr2.photo = UIImage(named: "pennywise")
        fr3.photo = UIImage(named: "freddie")
        fr4.photo = UIImage(named: "samara")
        fr5.photo = UIImage(named: "alessa")
        fr6.photo = UIImage(named: "maikl")
        fr7.photo = UIImage(named: "hannibal")
        fr8.photo = UIImage(named: "damien")
        fr9.photo = UIImage(named: "parker")
        
        return [fr1, fr2, fr3, fr4, fr5, fr6, fr7, fr8, fr9].sorted {$0.lastName! < $1.lastName!}
        
    }()
    //MARK: - Elements
    let searchBar = UISearchBar()
    var addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))

    private func setupViews() {
        createKeys()
        self.addFriendButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
        self.tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Friends"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        self.navigationItem.rightBarButtonItem  = addFriendButton
        self.navigationItem.titleView = searchBar
    }
    
    private func createKeys() {
        keys.removeAll()
        for i in friends {
            if keys.contains((i.lastName?.first)!) { }
            else {
                keys.append((i.lastName?.first)!)
            }
        }
        print(keys.count)
    }
    private func sortFriendsToSection(title: Character) {
        sortedFriends.removeAll()
        for i in friends {
            if i.lastName?.first == title {
                sortedFriends.append(i)
            }
        }
        print(sortedFriends.count)
    }
    
    @objc func addFriend() {
        performSegue(withIdentifier: "addFriend", sender: self)
    }
    

}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedFriends.removeAll()
        if searchText != "" {
        for i in friends {
            if i.lastName!.contains(searchText) {
                searchedFriends.append(i)
            } 
        }
        } else { searchedFriends = friends }
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
