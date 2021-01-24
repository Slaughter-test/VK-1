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
    var groups: Array<Group> = []
    
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
