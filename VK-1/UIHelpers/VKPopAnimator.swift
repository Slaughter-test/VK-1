//
//  VKPopAnimator.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class VKPopAnimator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    private let timeInterval: TimeInterval = 0.7
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timeInterval
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else {
            return }
                guard let destination = transitionContext.viewController(forKey: .to) else { return }
                
                transitionContext.containerView.addSubview(destination.view)
                transitionContext.containerView.sendSubviewToBack(destination.view)
                
        let pipi = CGFloat.pi
        destination.view.frame = source.view.frame
        destination.view.transform = CGAffineTransform(rotationAngle: pipi / 2)
        destination.view.layer.anchorPoint = CGPoint(x: 0, y: 0)
        destination.view.layer.position = CGPoint(x: 0, y: 0)
        
        source.view.layer.anchorPoint = destination.view.layer.anchorPoint
        source.view.layer.position = destination.view.layer.position
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModePaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.75,
                                                       animations: {
                                                           source.view.transform = CGAffineTransform(rotationAngle: -pipi / 2)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.2,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                           destination.view.transform = CGAffineTransform(rotationAngle: pipi / 2)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                           destination.view.transform = .identity
                                    })
                                            
                                            
                }) { finished in
                    if finished && !transitionContext.transitionWasCancelled {
                        source.removeFromParent()
                    } else if transitionContext.transitionWasCancelled {
                        destination.view.transform = .identity
                    }
                    transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
                }
            }
}
