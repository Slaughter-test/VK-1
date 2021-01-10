//
//  NewFriendsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 04.01.2021.
//

import UIKit

class NewFriendsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupViews()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendsTableViewCell
        cell.friend = friends[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAddFriend(indexPath: indexPath)
    }

    //MARK: - Data
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
    
    private func setupViews() {

        self.tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Friends"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)

    }
    
    func convertFriend(indexPath: IndexPath) {
        friends.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    private func showAddFriend(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Добавить в друзья", message: "Вы действительно хотите добавить этого человека в друзья?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self]action in convertFriend( indexPath: indexPath)})
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
}
