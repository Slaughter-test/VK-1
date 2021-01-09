//
//  VKViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class VKViewController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    let interactiveTransition = VKTransition()

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
                              -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return VKPushAnimator()
        }else if operation == .pop {
            self.interactiveTransition.viewController = toVC
            return VKPopAnimator()
        }else {
            return nil
        }
    }

}

