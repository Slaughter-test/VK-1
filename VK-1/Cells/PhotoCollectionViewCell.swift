//
//  PhotoCollectionViewCell.swift
//  VK-1
//
//  Created by Юрий Егоров on 09.01.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    var photo: Photo? {
        didSet {
            photoImageView.downloaded(from: photo!.photo)
            }
        }
    
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
    
    private func setupViews() {
        self.addSubview(photoImageView)
        self.backgroundColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false

        addConstraintsWithFormat("V:|-0-[v0]-0-|", views: photoImageView)
        addConstraintsWithFormat("H:|-0-[v0]-0-|", views: photoImageView)
    }
    
}
