//
//  PhotoViewController.swift
//  VK-1
//
//  Created by Юрий Егоров on 06.01.2021.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photos = [UIImage](arrayLiteral: UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!, UIImage(named: "4")!, UIImage(named: "5")!)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    //MARK: - Variables
    
    var nextIndex = 0
    var currentPicture: UIImageView?


    private func createPicture() -> UIImageView? {
        guard nextIndex < photos.count else { return nil }
        
        let imageView = UIImageView(image: photos[nextIndex])
        imageView.frame  = CGRect(x: self.view.frame.width, y: self.view.center.y / 2, width: self.view.frame.width, height: 300)
        imageView.isUserInteractionEnabled = true
        
        nextIndex += 1
        
        return imageView
    }
    
    private func createOldPicture() -> UIImageView? {
        guard nextIndex < photos.count else { return nil }
        if nextIndex != 0 {
        let imageView = UIImageView(image: photos[nextIndex])
        imageView.frame  = CGRect(x: self.view.frame.width, y: self.view.center.y / 2, width: self.view.frame.width, height: 300)
        imageView.isUserInteractionEnabled = true
        
        nextIndex -= 1
            return imageView
        } else {
            let imageView = UIImageView(image: photos[photos.count - 1])
            imageView.frame  = CGRect(x: self.view.frame.width, y: self.view.center.y / 2, width: self.view.frame.width, height: 300)
            imageView.isUserInteractionEnabled = true
            nextIndex = photos.count + 1

            return imageView
            
        }
    }
    
    private func showNewPicture(_ imageView: UIImageView) {
        self.view.addSubview(imageView)
        imageView.center = self.view.center
        imageView.frame.size.height -= 100
        imageView.alpha = 0.0
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.frame.size.height += 50
                                                        imageView.alpha = 0.25

                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.frame.size.height += 50
                                                        imageView.alpha = 0.5
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.alpha = 0.75
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.75,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.alpha = 1
                                                       })
                                },
                                completion: nil)
        }
    
    private func showOldPicture(_ imageView: UIImageView) {
        self.view.addSubview(imageView)
        imageView.center = self.view.center
        imageView.frame.size.height -= 100
        imageView.alpha = 0.0
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.frame.size.height += 50
                                                        imageView.alpha = 0.25

                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.frame.size.height += 50
                                                        imageView.alpha = 0.5
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.alpha = 0.75
                                                       })
                                    UIView.addKeyframe(withRelativeStartTime: 0.75,
                                                       relativeDuration: 0.25,
                                                       animations: {
                                                        imageView.alpha = 1
                                                       })
                                },
                                completion: nil)
        }
    
    private func showNextPicture() {
        if let newPicture = createPicture() {
            currentPicture = newPicture
            showNewPicture(newPicture)
            
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeForNew))
            let swipe2 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeForOld))
            swipe.direction = .left
            swipe2.direction = .right
            newPicture.addGestureRecognizer(swipe)
            newPicture.addGestureRecognizer(swipe2)
        } else {
            nextIndex = 0
            showNextPicture()
        }
    }
    private func showPreviousPicture() {
        if let oldPicture = createOldPicture() {
            currentPicture = oldPicture
            showOldPicture(oldPicture)

            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeForNew))
            let swipe2 = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeForOld))
            swipe.direction = .left
            swipe2.direction = .right
            oldPicture.addGestureRecognizer(swipe)
            oldPicture.addGestureRecognizer(swipe2)
            
        } else {
            nextIndex = photos.count - 1
            showPreviousPicture()
        }
    }
    @objc func handleSwipeForNew() {
        hidePictureLeft(currentPicture!)
        showNextPicture()
    }
    @objc func handleSwipeForOld() {
        hidePictureRight(currentPicture!)
        showPreviousPicture()
    }
    private func hidePictureLeft(_ imageView: UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            self.currentPicture?.frame.origin.x = -600
            self.currentPicture?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { _ in
            imageView.removeFromSuperview()
        }
    }
    private func hidePictureRight(_ imageView: UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            self.currentPicture?.frame.origin.x += 600
            self.currentPicture?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { _ in
            imageView.removeFromSuperview()
        }
    }
    
    private func setupViews() {
        
        self.view.backgroundColor = .black
        showNextPicture()
    }
}
