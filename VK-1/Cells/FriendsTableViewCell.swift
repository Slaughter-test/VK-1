//
//  FriendsTableViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 02.01.2021.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Elements
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
        
    }()
    var outerView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 3
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 50).cgPath
        
        return view
    }()
    var photo: UIImageView = {
        let imageview = UIImageView()
        return imageview
    }()
    //MARK: - Data
    var friend: Friend? {
        didSet {
            nameLabel.text = (friend?.firstName)! + " " + (friend?.lastName)!

        }
    }
    var imageforPhoto: UIImage? {
        didSet {
            photo.image = imageforPhoto
        }
    }
    let instets: CGFloat = 10.0


    
    //MARK: - Setup View
    private func setupViews() {
        self.addSubview(nameLabel)
        self.addSubview(outerView)
        photo.frame = outerView.bounds
        outerView.insertSubview(photo, at: 1)
        outerView.layer.cornerRadius = outerView.frame.size.width / 2
        photo.layer.cornerRadius = photo.frame.size.width / 2
        photo.clipsToBounds = true
        addConstraintsWithFormat("H:|-10-[v0(50)]-10-[v1]|", views: outerView, nameLabel)
        addConstraintsWithFormat("V:|-10-[v0]-10-|", views: nameLabel)
        addConstraintsWithFormat("V:|-10-[v0]-10-|", views: outerView)

    }
    func getLabelSize(text: String, font: UIFont) -> CGSize {
            let maxWidth = bounds.width - instets * 2
            let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            let width = Double(rect.size.width)
            let height = Double(rect.size.height)
            let size = CGSize(width: ceil(width), height: ceil(height))
            return size
    }
    func nameLabelFrame() {
            let nameLabelSize = getLabelSize(text: nameLabel.text!, font: nameLabel.font)
            let nameLabelX = (bounds.width - nameLabelSize.width) / 2
            let nameLabelOrigin =  CGPoint(x: nameLabelX, y: instets)
            nameLabel.frame = CGRect(origin: nameLabelOrigin, size: nameLabelSize)
    }
    func configure(with friend: Friend, photoService: PhotoService) {
        nameLabel.text =  "\(friend.firstName)" +  " " + "\(friend.lastName)"
        nameLabelFrame()
        let url = friend.photo
        photoService.getPhoto(urlString: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.photo.image = image
            }
        }
    }
}
