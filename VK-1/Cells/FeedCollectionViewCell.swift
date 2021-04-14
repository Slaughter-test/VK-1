//
//  FeedCollectionViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 01.01.2021.
//

import UIKit
import Kingfisher

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
    var post: Post? {
        didSet {
            if post?.userLikes == 0 {
                like = false
            }
            likesCount = post!.likes
            comments = post!.comments
            time = dateFormatter.string(from: Date(timeIntervalSince1970: post!.date))
            postedText = post!.text
            
        }
    }
        
        var like = true
        var likesCount = 0
        var comments = 0
        var postedText = ""
        var time = ""
        
        
        //MARK: Elements
        private let likedImage = UIImage(systemName: "heart.fill")
        private let unlikedImage = UIImage(systemName: "heart")
        private let likedTint = UIColor.red
        private let unlikedTint: UIColor = .brandPurple
        
        let dateFormatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.timeStyle = .short
        return dateformatter
        }()
        
        let avatarView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.contentMode = .scaleAspectFit
        return imageView
        }()
        let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
            label.font = .brandBoldFont
        return label
        }()
        let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .brandStandartFont
            label.textColor =  .brandBlack
        return label
        }()
        let postText: UILabel = {
        let label = UILabel()
            label.font = .brandStandartFont
        return label
        }()
        
        let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
        }()
        
        let dividedLineView: UIView = {
        let view = UIView()
            view.backgroundColor = .brandPurple
        return view
        }()
        let likeButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .brandStandartFont
        return button
        }()
        
        let commentButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .brandStandartFont
            button.tintColor = .brandPurple
        button.setImage(UIImage(systemName: "message"), for: .normal)
        return button
        }()
        
        let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .brandStandartFont
            button.tintColor = .brandPurple
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        return button
        }()
        
        private func setupViews() {
        backgroundColor = UIColor.white
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(photoImageView)
        contentView.addSubview(dividedLineView)
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(postText)
        
        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: postText)
        addConstraintsWithFormat("V:|-14-[v0(20)]-4-[v1(14)]-8-[v2]-8-[v3]-4-[v4(2)]-4-[v5(44)]-4-|", views: nameLabel, dateLabel, postText, photoImageView,dividedLineView, likeButton)
        likeButton.setTitle(String(self.likesCount), for: .normal)
        likeButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: avatarView, nameLabel)
        addConstraintsWithFormat("H:|-60-[v0]-|", views: dateLabel)
        addConstraintsWithFormat("V:|-8-[v0(44)]|", views: avatarView)
        addConstraintsWithFormat("H:|[v0]|", views: photoImageView)
        addConstraintsWithFormat("H:|[v0]|", views: dividedLineView)
        addConstraintsWithFormat("H:|-8-[v0]-8-[v1(v0)]-8-[v2(v1)]|", views: likeButton, commentButton,shareButton)
        shareButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        
        
        }
        
        public func updateChanges() {
        commentButton.setTitle("\(comments)", for: .normal)
        likeButton.setTitle("\(likesCount)", for: .normal)
        if post?.userLikes != 0 {
        likeButton.tintColor = .systemRed
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = .brandPurple
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        postText.text = postedText
        postText.textAlignment = .left
        postText.numberOfLines = 4
        dateLabel.text = time
        avatarView.downloaded(from: post!.avatar)
        nameLabel.text = post!.name
        if post?.photos != [] {
        photoImageView.downloaded(from: post!.photos[0])
        photoImageView.contentMode = .scaleToFill
        
        }
        
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

