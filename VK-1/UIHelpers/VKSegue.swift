//
//  VKSegue.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class VKSegue: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        toViewController.modalPresentationStyle = .fullScreen
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            toViewController.view.transform = CGAffineTransform.identity
        } completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
        }

    }
}
