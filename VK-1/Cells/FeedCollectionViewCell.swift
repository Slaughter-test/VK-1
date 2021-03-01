//
//  FeedCollectionViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 01.01.2021.
//

import UIKit

class FeedCollectionViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Data
    var like = true
    var likesCount = 200
    
    //MARK: Elements
    private let likedImage = UIImage(systemName: "heart.fill")
    private let unlikedImage = UIImage(systemName: "heart")
    private let likedTint = UIColor.red
    private let unlikedTint = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
    
    let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kitana")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "Kitana Khan"
        label.font = UIFont.boldSystemFont(ofSize: 16)
       return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "30.02.2020"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor =  UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)
        return label
    }()
    let postText: UILabel = {
        let label = UILabel()
        label.text = "В отличие от большинства других языков программирования, Bash не производит разделения переменных по типам. По сути, переменные Bash являются строковыми переменными, но, в зависимости от контекста, Bash допускает целочисленную арифметику с переменными. Определяющим фактором здесь служит содержимое переменных."
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 4
        return label
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = (UIImage(named: "3"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let dividedLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        return view
    }()
    let likeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("228", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        button.setImage(UIImage(systemName: "message"), for: .normal)
       return button
    }()
    
    let shareButton: UIButton = {
       let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.tintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
       return button
    }()
    
    private func setupViews() {
        backgroundColor = UIColor.white
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(postText)
        contentView.addSubview(photoImageView)
        contentView.addSubview(dividedLineView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        likeButton.setTitle(String(self.likesCount), for: .normal)
        likeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if like == true {
            likeButton.tintColor = .systemRed
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: avatarView, nameLabel)
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: postText)
        addConstraintsWithFormat("H:|-60-[v0]-|", views: dateLabel)
        addConstraintsWithFormat("V:|-8-[v0(44)]|", views: avatarView)
        addConstraintsWithFormat("V:|-14-[v0(20)]-4-[v1(14)]-8-[v2(100)]-8-[v3]-4-[v4(2)]-4-[v5(44)]-4-|", views: nameLabel, dateLabel, postText, photoImageView,dividedLineView, likeButton)
        addConstraintsWithFormat("H:|[v0]|", views: photoImageView)
        addConstraintsWithFormat("H:|[v0]|", views: dividedLineView)
        addConstraintsWithFormat("H:|-8-[v0]-8-[v1(v0)]-8-[v2(v1)]|", views: likeButton, commentButton,shareButton)
        addConstraintsWithFormat("V:|-453-[v0(44)]-|", views: commentButton)
        addConstraintsWithFormat("V:|-453-[v0(44)]-|", views: shareButton)

        
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
               let newImage = self.like ? self.likedImage : self.unlikedImage
               let newTint = self.like ? self.likedTint : self.unlikedTint
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
}
