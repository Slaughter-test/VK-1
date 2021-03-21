//
//  FeedCollectionViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 01.01.2021.
//

import UIKit

private let reuseIdentifier = "feedCell"

class FeedCollectionViewController: UITableViewController {
    
    let networkService = NewsFeedService()
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(FeedCollectionViewCell.self, forCellReuseIdentifier: "feedCell")
        self.tableView?.backgroundColor = UIColor(white: 0.90, alpha: 1)
        self.tableView?.delaysContentTouches = false
        setupViews()
        
        networkService.getPosts { posts in
            self.posts = posts
            self.tableView.reloadData()
        }
            
        //MARK: - Pull to Refresh
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)

            // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
            self.tableView.refreshControl = refreshControl
    
        
        
    }
    

    // MARK: - UICollectionViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        cell.post = posts[indexPath.row]
        cell.backgroundColor = .white
        cell.isUserInteractionEnabled = true
        cell.selectionStyle = .none
        cell.updateChanges()
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.topItem?.title = "Feed"
        let backButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(exit))
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        self.navigationController?.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = backButton

    }
    
    @objc func exit() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                Darwin.exit(0)
             }
        }
    }
    
    @objc private func updateData() {
         networkService.getPosts { posts in
             self.posts = posts
             self.tableView.reloadData()
             self.refreshControl?.endRefreshing()
         }
         
     }
}
