//
//  Extension.swift
//  Chat_Up
//
//  Created by Yifan Du on 8/5/21.
//

import Foundation
import UIKit

extension UIView {
    func shake(horizontally: CGFloat = 0, Vertically: CGFloat = 5) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - horizontally, y: self.center.y - Vertically))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + horizontally, y: self.center.y + Vertically))
        self.layer.add(animation, forKey: nil)
    }
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 3
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
}

class PurpleSquareButton : UIButton {
    // we need to initiate the object
    private let size : CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        settingUp() // we must initiate the function inside this initializer
      
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingUp() {
       
        self.setTitle("光", for: .normal)
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        self.frame.size.height = size
        self.frame.size.width = size
        self.layer.cornerRadius = 15
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        self.frame = CGRect(x: 150 - 50, y: 150, width: 80, height: 80)
        
    }// this is called block or closure

    @objc func handleTap() {
        self.pulse()
    }

    
}


class PinkSquareButton : UIButton {
    // we need to initiate the object
    private let size : CGFloat = 100

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        settingUp2()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    func settingUp2() {
       
        self.setTitle("Shade", for: .normal)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.frame.size.height = size
        self.frame.size.width = size
        self.layer.cornerRadius = 15
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        self.frame = CGRect(x: 200 + 50, y: 200, width: 80, height: 80)
        
    }// this is called block or closure
    @objc func handleTap() {
        self.pulse()
    }

    
}
