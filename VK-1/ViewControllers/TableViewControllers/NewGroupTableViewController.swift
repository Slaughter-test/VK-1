//
//  NewGroupTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class NewGroupTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        setupViews()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
        cell.group = groups[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAddGroup(indexPath: indexPath)
    }

    //MARK: - Data
    var groups: Array<Group> = {
        let fr1 = Group()
        let fr2 = Group()
        let fr3 = Group()
        let fr4 = Group()
        let fr5 = Group()
        let fr6 = Group()
        let fr7 = Group()
        let fr8 = Group()
        let fr9 = Group()
        fr1.title = "John"
        fr2.title = "Clown"
        fr3.title = "Freddie"
        fr4.title = "Samara"
        fr5.title = "Alessa"
        fr6.title = "Michael"
        fr7.title = "Dr."
        fr8.title = "Damien"
        fr9.title = "Parker"
        fr1.photo = UIImage(named: "kramer")
        fr2.photo = UIImage(named: "pennywise")
        fr3.photo = UIImage(named: "freddie")
        fr4.photo = UIImage(named: "samara")
        fr5.photo = UIImage(named: "alessa")
        fr6.photo = UIImage(named: "maikl")
        fr7.photo = UIImage(named: "hannibal")
        fr8.photo = UIImage(named: "damien")
        fr9.photo = UIImage(named: "parker")
        
        return [fr1, fr2, fr3, fr4, fr5, fr6, fr7, fr8, fr9].sorted {$0.title! < $1.title!}
        
    }()
    
    private func setupViews() {

        self.tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)

    }
    
    func convertGroups(indexPath: IndexPath) {
        groups.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
    
    private func showAddGroup(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Войти в группу", message: "Вы действительно хотите войти в эту группу?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self]action in convertGroups( indexPath: indexPath)})
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: nil)
            alert.addAction(action)
            alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
}
