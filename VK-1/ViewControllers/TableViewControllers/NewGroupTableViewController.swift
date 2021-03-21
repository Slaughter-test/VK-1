//
//  NewGroupTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit
import RealmSwift
import PromiseKit


class NewGroupTableViewController: UITableViewController {
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        updateData()
        
        setupViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
        cell.group = groupList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAddGroup(indexPath: indexPath)
    }

    //MARK: - Data
    var groupList = [Group]()
    
    private func setupViews() {

        self.tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255,
                                                                        green: 179/255,
                                                                        blue: 225/255,
                                                                        alpha: 0.95)

    }
    
    
    private func showAddGroup(indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Войти в группу", message: "Вы действительно хотите войти в группу \(groupList[indexPath.row].name) ?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            self.networkService.joinGroup(id: groupList[indexPath.row].id )
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: {_ in 
            self.tableView.reloadData()
        })
            
            
        alert.addAction(action)
        alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func updateData() {

        self.refreshControl?.beginRefreshing()
        networkService.getGroupsCatalog(on: .global())
            .get { [weak self] groups in
                guard self != nil else { return }
                self?.groupList = groups
            }
            .done(on: .main) { _ in
                self.refreshControl?.endRefreshing()
            }
             .catch { error in
                print(error)
            }.finally {
                self.tableView.reloadData()
    }
    }
}
