//
//  FullPhotoCollectionViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit

class FullPhotoCollectionViewCell: UICollectionViewCell{
    
    var isLiked: Bool?
    var userId: Int?
    var photoId: Int?
    let networkService = NetworkService()
    var likesCount: Int?
    var photo: Photo? {
        didSet {
            photoImageView.downloaded(from: photo!.photo)
            if photo?.like?.userLikes == 0 {
                self.isLiked = false
            } else {
                self.isLiked = true
            }
            self.photoId = photo?.id
            self.likesCount = photo?.like?.count
        }
    }
    
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
        button.titleLabel?.font = .brandStandartFont
        return button
    }()
    
    
    private func setupViews() {
        self.addSubview(photoImageView)
        photoImageView.isUserInteractionEnabled = true
        self.addSubview(likeButton)
        likeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonAction))
            tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        
        addConstraintsWithFormat("V:|-10-[v0(44)]|", views: likeButton)
        addConstraintsWithFormat("H:|-10-[v0(44)]|", views: likeButton)
        addConstraintsWithFormat("V:|-0-[v0]-0-|", views: photoImageView)
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: photoImageView)
    }
    
    private func toggleLike() {
        if self.isLiked == true {
            networkService.removeLike(String(userId!), String(photoId!), completion: { [weak self] success in
                if success == true {
                    self?.isLiked = false
                    self?.likesCount! -= 1
                    self?.likeButton.setTitle(String(self!.likesCount!), for: .normal)
                }
    })
        } else {
            networkService.setLike(String(userId!), String(photoId!), completion: {
                [weak self] success in
                if success == true {
                    self?.isLiked = true
                    self?.likesCount! += 1
                    self?.likeButton.setTitle(String(self!.likesCount!), for: .normal)
                }
            })
        }
    }
        
       @objc func buttonAction() {
           toggleLike()
           animate()
       }
       
       private func animate() {
           UIView.animate(withDuration: 0.1, animations: {
            let newImage = self.isLiked! ? self.unlikedImage : self.likedImage
               let newTint = self.isLiked! ? self.unlikedTint : self.likedTint
               self.likeButton.transform = self.transform.scaledBy(x: 2, y: 2)
               self.likeButton.setImage(newImage, for: .normal)
               self.likeButton.tintColor = newTint
            self.likeButton.setTitleColor(newTint, for: .normal)
           }, completion: {_ in
               UIView.animate(withDuration: 0.1, animations: {
                   self.likeButton.transform = CGAffineTransform.identity
               })
           })
       }
    public func updateLike() {
        if isLiked == true {
            likeButton.tintColor = .systemRed
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.setTitleColor(.systemRed, for: .normal)

        } else {
            likeButton.tintColor = .brandPurple
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.setTitleColor(.brandPurple , for: .normal)
        }
        likeButton.setTitle(String(self.likesCount!), for: .normal)
    }
}
