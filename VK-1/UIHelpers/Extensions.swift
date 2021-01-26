//
//  Extensions.swift
//  VK-1
//
//  Created by Юрий Егоров on 19.01.2021.
//

import UIKit
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
