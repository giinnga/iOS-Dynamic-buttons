//
//  RoundedButton.swift
//  addButtonDynamics
//
//  Created by Victor Souza on 11/24/15.
//  Copyright © 2015 Victor Souza. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIView {
    
    var circleColor: UIView?
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        
        circleColor = UIView(frame: CGRect(x: self.frame.width/3, y: self.frame.width/3, width: self.frame.width/3, height: self.frame.width/3))
        circleColor?.backgroundColor = UIColor.whiteColor()
        circleColor?.layer.cornerRadius = self.frame.width/6
        circleColor?.backgroundColor = UIColor(red: 0.2007, green: 0.2855, blue: 0.3709, alpha: 1.0)
        self.addSubview(circleColor!)
        
        self.backgroundColor = UIColor.redColor()
        self.layer.cornerRadius = self.frame.width/2
        self.layer.shadowOpacity = 0.75
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 2.0
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        self.layer.shadowPath = path.CGPath
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        print(self.frame.origin.x, imageView.frame.origin.x)
        self.addSubview(imageView)
    }
    
    func updateImage(image: UIImage) {
        
        imageView?.removeFromSuperview()
        
        imageView = UIImageView(image: image)
        imageView!.frame = CGRectZero
        imageView!.center = CGPoint(x: self.frame.width/2, y: self.frame.width/2)
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.imageView!.frame.origin.x -= self.frame.width/2
            self.imageView!.frame.origin.y -= self.frame.height/2
            self.imageView!.frame.size.width += self.frame.width
            self.imageView!.frame.size.height += self.frame.height
        })
        
        self.addSubview(imageView!)
    }
    
    func changeColor() {
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = self.frame.width/6
        animation.toValue = 0
        animation.duration = 0.4
        self.circleColor?.layer.cornerRadius = 0
        self.circleColor?.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.circleColor!.frame.origin.x += self.frame.width/6
            self.circleColor!.frame.origin.y += self.frame.width/6
            self.circleColor!.frame.size.width -= self.frame.width/3
            self.circleColor!.frame.size.height -= self.frame.width/3
            })
    }
    
    func normalPosition() {
        
        let animation = CABasicAnimation(keyPath: "normalState")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = self.frame.width/6
        animation.duration = 0.4
        self.circleColor?.layer.cornerRadius = self.frame.width/6
        self.circleColor?.layer.addAnimation(animation, forKey: "normalState")
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.circleColor!.frame.origin.x -= self.frame.width/6
            self.circleColor!.frame.origin.y -= self.frame.width/6
            self.circleColor!.frame.size.width += self.frame.width/3
            self.circleColor!.frame.size.height += self.frame.width/3
            
            self.imageView!.frame.origin.x += self.frame.width/2
            self.imageView!.frame.origin.y += self.frame.height/2
            self.imageView!.frame.size.width -= self.frame.width
            self.imageView!.frame.size.height -= self.frame.height
            
            })
    }
}