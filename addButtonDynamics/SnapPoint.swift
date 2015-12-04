//
//  SnapPoint.swift
//  addButtonDynamics
//
//  Created by Victor Souza on 11/24/15.
//  Copyright © 2015 Victor Souza. All rights reserved.
//

import Foundation
import UIKit

class SnapPoint: UIView {
    
    var circleColor: UIColor?
    var snap: CGPoint?
    var image: UIImage?
    
    init(frame: CGRect, color: UIColor, snap: CGPoint, image: UIImage) {
        super.init(frame: frame)
        self.circleColor = color
        self.snap = snap
        self.image = image
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        
        self.backgroundColor = circleColor
        self.layer.cornerRadius = self.frame.width/2
        self.layer.shadowOpacity = 0.75
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 2.0
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.frame.width/2)
        self.layer.shadowPath = path.CGPath
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        print(self.frame.origin.x, imageView.frame.origin.x)
        self.addSubview(imageView)
    }
}