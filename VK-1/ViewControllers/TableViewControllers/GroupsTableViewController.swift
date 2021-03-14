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
        realmObserver()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self

        self.tableView.reloadData()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        self.refreshControl = refreshControl
        updateData()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.token?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        realmObserver()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        updateData()
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == false {
            return groupList?.count ?? 0
        } else { return searchedGroups!.count }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
        if searching == false {
            cell.group = groupList?[indexPath.row] } else { cell.group = searchedGroups![indexPath.row] }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PhotoCollectionViewController2") as! PhotoCollectionViewController
        vc.id = groupList?[indexPath.row].id ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                showDeleteGroup(indexPath: indexPath)
            }
        }
    
    
    // MARK: - variables
    var keys = [Character]()
    var searching = false
    var searchedGroups: Results<Group>?
    let networkService = NetworkService()
    private lazy var groupList = try? Realm().objects(Group.self).sorted(byKeyPath: "name")
    var token: NotificationToken?

    
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
    @objc
    private func updateData() {

        self.refreshControl?.beginRefreshing()
        networkService.loadGroupList(on: .global())
            .get { [weak self] groups in
                guard self != nil else { return }
                self?.networkService.saveList(groups)
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
    
    private func showDeleteGroup(indexPath: IndexPath) {
        let group = groupList![indexPath.row]
        let alert = UIAlertController(title: "Выйти из группы?", message: "Вы действительно хотите выйти из группы \(groupList![indexPath.row].name)" + "?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
            self.networkService.deleteGroup(id: groupList![indexPath.row].id)
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(group)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        })
        let action2 = UIAlertAction(title: "No", style: .destructive, handler: {_ in
            self.tableView.reloadData()
        })
            alert.addAction(action)
            alert.addAction(action2)
        
        present(alert, animated: true, completion: nil)
    }
    
    func realmObserver() {
        self.token = groupList?.observe {  (changes: RealmCollectionChange) in
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
                }


    }
    
    @objc func addGroup() {
        performSegue(withIdentifier: "addGroup", sender: self)
    }

}

extension GroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchedGroups = groupList!.filter("name contains '\(searchText)'")
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
