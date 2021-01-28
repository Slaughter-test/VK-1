//
//  GroupsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self

        networkService.loadGroupList( completion: { [weak self] groups in
            self?.loadData()
            self?.tableView.reloadData()

        })
        
        setupViews()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return groupList.count
        } else { return searchedGroups.count }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
        if searching == false {
            cell.group = groupList[indexPath.row] } else { cell.group = searchedGroups[indexPath.row] }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PhotoCollectionViewController2") as! PhotoCollectionViewController
        vc.id = groupList[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - variables
    var keys = [Character]()
    var sortedGroups: Array<Group> = []
    var searching = false
    var searchedGroups: Array<Group> = []
    let networkService = NetworkService()
    private var groupList = [Group]()
    
    //MARK: - Elements
    let searchBar = UISearchBar()
    var addGroupButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))

    private func setupViews() {
        self.addGroupButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        self.tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        self.navigationItem.rightBarButtonItem  = addGroupButton
        self.navigationItem.titleView = searchBar
    }
    
    @objc func addGroup() {
        performSegue(withIdentifier: "addGroup", sender: self)
    }
    func loadData() {
        do {
                   let realm = try Realm()
                   
                   let groups = realm.objects(Group.self).sorted(byKeyPath: "name")
                   
                   self.groupList = Array(groups)
                   
               } catch {
       // если произошла ошибка, выводим ее в консоль
                   print(error)
               }

    }
    

}

extension GroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGroups.removeAll()
        if searchText != "" {
        for i in groupList {
            if i.name.contains(searchText) {
                searchedGroups.append(i)
            }
        }
        } else { searchedGroups = groupList }
        searching = true
        self.tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:  #selector(self.searchBarCancelButtonClicked(_:)))
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        self.searchBar.text = ""
        self.tableView.reloadData()
        self.searchBar.endEditing(false)
        self.navigationItem.rightBarButtonItem  = self.addGroupButton
    }
}
