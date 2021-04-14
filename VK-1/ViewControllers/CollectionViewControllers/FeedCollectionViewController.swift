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
    private var nextFrom = ""
    var isLoading = false


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(FeedCollectionViewCell.self, forCellReuseIdentifier: "feedCell")
        self.tableView?.backgroundColor = .brandGrey
        self.tableView?.delaysContentTouches = false
        setupViews()
        networkService.getPosts { posts, next in
            self.posts = posts
            self.nextFrom = next
            self.tableView.reloadData()
        }
        self.tableView?.prefetchDataSource = self
        //MARK: - Pull to Refresh
            let refreshControl = UIRefreshControl()
            refreshControl.attributedTitle = NSAttributedString(string: "Refreshing")
            refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
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
            return 500
    }

    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.topItem?.title = "Feed"
        let backButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(exit))
        self.navigationController?.navigationBar.barTintColor = .brandPurple
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
        self.refreshControl?.beginRefreshing()
        let mostFreshNewsDate = self.posts.first?.date ?? Date().timeIntervalSince1970
        networkService.getPosts(startTime: mostFreshNewsDate + 1) { [weak self] posts,nextFrom  in
                   guard let self = self else { return }
                   self.refreshControl?.endRefreshing()
                   guard posts.count > 0 else { return }
                   self.posts = posts + self.posts
                   self.nextFrom = nextFrom
                   let indexSet = IndexSet(integersIn: 0..<posts.count)
                   self.tableView.insertSections(indexSet, with: .automatic)
               }
    }

}
extension FeedCollectionViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxRow = indexPaths.map({ $0.row}).max() else { return }
        if
            maxRow > posts.count - 3,
            !isLoading {
            isLoading = true
            networkService.getPosts(startFrom: nextFrom) { [weak self] (posts, nextFrom) in
                self?.posts.append(contentsOf: posts)
                self?.nextFrom = nextFrom
                self?.tableView.reloadData()
                self?.isLoading = false
            }
        }
    }
}

