//
//  PhotoCollectionViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var like: Bool?
    var likesCount: Int = 0
    
    private let likedImage = UIImage(systemName: "heart.fill")
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedTint = UIColor.red
    private let unlikedTint = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)

        return button
    }()
    
    private func setupViews() {
        self.addSubview(photoImageView)
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        photoImageView.addConstraintsWithFormat("V:|-8-[v0(50)]-8-|", views: likeButton)
        photoImageView.addConstraintsWithFormat("H:|-8-[v0(50)]-8-|", views: likeButton)
        photoImageView.isUserInteractionEnabled = true

        addConstraintsWithFormat("V:|-0-[v0]-0-|", views: photoImageView)
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: photoImageView)
    }
    
    private func toggleLike() {
        if like == true {
            like = false
            self.likesCount -= 1
        } else {
            like = true
            self.likesCount += 1
        }
    }
       @objc func buttonAction() {
           toggleLike()
           animate()
       }
       
       
       private func animate() {
           UIView.animate(withDuration: 0.1, animations: {
               let newImage = self.like! ? self.likedImage : self.unlikedImage
               let newTint = self.like! ? self.likedTint : self.unlikedTint
               self.likeButton.transform = self.transform.scaledBy(x: 2, y: 2)
               self.likeButton.setImage(newImage, for: .normal)
               self.likeButton.tintColor = newTint
            self.likeButton.setTitle(String(self.likesCount), for: .normal)
           }, completion: {_ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.likeButton.transform = CGAffineTransform.identity
               })
           })
       }
    
     public func updateStateOfLikeButton() {
        if like == true {
            likeButton.tintColor = .systemRed
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        likeButton.setTitle(String(self.likesCount), for: .normal)
    }
}
