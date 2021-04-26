//
//  PhotoCollectionViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let networkService = NetworkService()
    var id: Int = 0
    var photos = Array<Photo>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        networkService.loadPhotosList(id, completion: { [weak self] photos in
            self?.photos = photos
            self?.collectionView.reloadData()

        })
        setupViews()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photo = photos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width / 3 - 1, height: view.bounds.width / 3 - 1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "PhotoViewController1") as! PhotoViewController
        vc.photos = photos
        vc.indexPath = indexPath
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupViews() {
        self.navigationController?.navigationBar.barTintColor = .brandPurple
        self.collectionView?.backgroundColor = .brandGrey

    }

}
