//
//  FeedCollectionViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 01.01.2021.
//

import UIKit

private let reuseIdentifier = "feedCell"

class FeedCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "feedCell")
        self.collectionView?.backgroundColor = UIColor(white: 0.90, alpha: 1) 
        setupViews()

    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCollectionViewCell
        cell.backgroundColor = .white
    
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 500)
    }
    private func setupViews() {
        self.navigationController?.navigationBar.topItem?.title = "Feed"
        let backButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(exit))
        self.navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        self.navigationController?.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = backButton

    }
    @objc func exit() {
        self.performSegue(withIdentifier: "unwindToRootViewController", sender: self)
    }

}
