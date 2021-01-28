//
//  PhotoViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class PhotoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var userId: Int?
    var photos:[Photo] = []
    var indexPath:IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        collectionView.register(FullPhotoCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
            self.collectionView.scrollToItem(at: self.indexPath,
                                             at: .centeredHorizontally,
                                             animated: false)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FullPhotoCollectionViewCell
        cell.photo = photos[indexPath.row]
        cell.userId = userId
        cell.updateLike()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    private func setupViews() {
        
        collectionView.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        collectionView.isPagingEnabled = true

    }
    
    
}

