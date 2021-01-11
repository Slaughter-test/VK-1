//
//  FullPhotoCollectionViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit

class FullPhotoCollectionViewCell: UICollectionViewCell{
    
    var isLiked: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Elements
    
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: Elements
    private let likedImage = UIImage(systemName: "heart.fill")
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedTint = UIColor.red
    private let unlikedTint = UIColor.white
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    
    private func setupViews() {
        self.addSubview(photoImageView)
        photoImageView.isUserInteractionEnabled = true
        self.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if isLiked == true {
            likeButton.tintColor = .systemRed
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

        
        
        addConstraintsWithFormat("V:|-10-[v0(44)]|", views: likeButton)
        addConstraintsWithFormat("H:|-10-[v0(44)]|", views: likeButton)
        addConstraintsWithFormat("V:|-0-[v0]-0-|", views: photoImageView)
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: photoImageView)
    }
    
    private func toggleLike() {
        if isLiked == true {
            isLiked = false
        } else {
            isLiked = true
        }
    }
       @objc func buttonAction() {
           toggleLike()
           animate()
       }
       
       private func animate() {
           UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked! ? self.likedImage : self.unlikedImage
               let newTint = self.isLiked! ? self.likedTint : self.unlikedTint
               self.likeButton.transform = self.transform.scaledBy(x: 2, y: 2)
               self.likeButton.setImage(newImage, for: .normal)
               self.likeButton.tintColor = newTint
           }, completion: {_ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.likeButton.transform = CGAffineTransform.identity
               })
           })
       }
}
