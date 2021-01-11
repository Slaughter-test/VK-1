//
//  GroupsTableViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class GroupsTableViewController: UITableViewController {

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
            return sortedGroups.count
        } else { return searchedGroups.count }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupsTableViewCell
        if searching == false {
            let key = keys[indexPath.section]
            sortFriendsToSection(title: key)
            cell.group = sortedGroups[indexPath.row] } else { cell.group = searchedGroups[indexPath.row] }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            createKeys()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PhotoCollectionViewController2") as! PhotoCollectionViewController
        vc.photos = groups[indexPath.row].photos!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - variables
    var keys = [Character]()
    var sortedGroups: Array<Group> = []
    var searching = false
    var searchedGroups: Array<Group> = []
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
        fr5.title = "Gillespi"
        fr6.title = "Myers"
        fr7.title = "Salazar"
        fr8.title = "Thorn"
        fr9.title = "Kreyn"
        let ph1 = Photo()
        let ph2 = Photo()
        let ph3 = Photo()
        let ph4 = Photo()
        ph1.image = UIImage(named: "kitana")
        ph2.image = UIImage(named: "2")
        ph3.image = UIImage(named: "3")
        ph4.image = UIImage(named: "freddie")
        ph1.isliked = true
        ph2.isliked = false
        ph3.isliked = true
        ph4.isliked = false
        ph1.likesCount = 1
        ph2.likesCount = 3
        ph3.likesCount = 123
        ph4.likesCount = 5435
        fr1.photo = UIImage(named: "kramer")
        fr2.photo = UIImage(named: "pennywise")
        fr3.photo = UIImage(named: "freddie")
        fr4.photo = UIImage(named: "samara")
        fr5.photo = UIImage(named: "alessa")
        fr6.photo = UIImage(named: "maikl")
        fr7.photo = UIImage(named: "hannibal")
        fr8.photo = UIImage(named: "damien")
        fr9.photo = UIImage(named: "parker")
        fr1.photos = [ph1, ph2, ph3, ph4]
        fr2.photos = [ph1, ph2, ph3, ph4]
        fr3.photos = [ph1, ph2, ph3, ph4]
        fr4.photos = [ph1, ph2, ph3, ph4]
        fr5.photos = [ph1, ph2, ph3, ph4]
        fr6.photos = [ph1, ph2, ph3, ph4]
        fr7.photos = [ph1, ph2, ph3, ph4]
        fr8.photos = [ph1, ph2, ph3, ph4]
        fr9.photos = [ph1, ph2, ph3, ph4]

        return [fr1, fr2, fr3, fr4, fr5, fr6, fr7, fr8, fr9].sorted {$0.title! < $1.title!}
        
    }()
    //MARK: - Elements
    let searchBar = UISearchBar()
    var addGroupButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))

    private func setupViews() {
        createKeys()
        self.addGroupButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        self.tableView.register(GroupsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        self.navigationItem.rightBarButtonItem  = addGroupButton
        self.navigationItem.titleView = searchBar
    }
    
    private func createKeys() {
        keys.removeAll()
        for i in groups {
            if keys.contains((i.title?.first)!) { }
            else {
                keys.append((i.title?.first)!)
            }
        }
        print(keys.count)
    }
    private func sortFriendsToSection(title: Character) {
        sortedGroups.removeAll()
        for i in groups {
            if i.title?.first == title {
                sortedGroups.append(i)
            }
        }
        print(sortedGroups.count)
    }
    
    @objc func addGroup() {
        performSegue(withIdentifier: "addGroup", sender: self)
    }
    

}

extension GroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedGroups.removeAll()
        if searchText != "" {
        for i in groups {
            if i.title!.contains(searchText) {
                searchedGroups.append(i)
            }
        }
        } else { searchedGroups = groups }
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
