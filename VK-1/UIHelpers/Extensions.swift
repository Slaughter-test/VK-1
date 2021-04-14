//
//  Extensions.swift
//  VK-1
//
//  Created by Юрий Егоров on 19.01.2021.
//

import UIKit
import Foundation
import Kingfisher

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        self.kf.setImage(with: url)
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
extension UIColor {
    
    static let brandPurple = UIColor(displayP3Red: 179/255, green: 179/255, blue: 225/255, alpha: 0.95)
    
    static let brandGrey = UIColor(white: 0.90, alpha: 1)
    
    static let brandBlack = UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)
}

extension UIFont {
    
    static let brandBoldFont = UIFont.boldSystemFont(ofSize: 16)
    
    static let brandStandartFont = UIFont.systemFont(ofSize: 14)
}
