//
//  Loader.swift
//  VK-1
//
//  Created by Юрий Егоров on 04.01.2021.
//

import UIKit

class Loader: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func hideLoader() {
        self.layer.isHidden = true
    }
    
    func showLoader() {
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0,y: 0,width: 20,height: 20))
        let lay = CAReplicatorLayer()
        lay.frame = CGRect(x: 0,y: 0,width: 200,height: 20)
        
        let bar = CAShapeLayer()
        bar.path = path.cgPath
        bar.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        bar.backgroundColor = UIColor.clear.cgColor
        bar.fillColor = UIColor.red.cgColor
            
        lay.addSublayer(bar)
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(40, 0, 0)
            let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
            anim.fromValue = 1.0
            anim.toValue = 0.0
            anim.duration = 2.5
            anim.repeatCount = .infinity
            bar.add(anim, forKey: nil)
            lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        self.layer.addSublayer(lay)
    }
}
