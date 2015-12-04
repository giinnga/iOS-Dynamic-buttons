//
//  ButtonCapsule.swift
//  addButtonDynamics
//
//  Created by Victor Souza on 11/24/15.
//  Copyright © 2015 Victor Souza. All rights reserved.
//

import Foundation
import UIKit

class ButtonCapsule: UIView {
    
    var button: RoundedButton?
    var circle: UIView?
    var radius: CGFloat?
    var snapPoints: [CGPoint?] = []
    var centerPoint: CGPoint?
    var colors: [UIColor?] = []
    var points: [SnapPoint?] = []
    var numberOfPoints: CGFloat?
    var animator: UIDynamicAnimator?
    var attachmentBehavior: UIAttachmentBehavior?
    var snapBehavior: UISnapBehavior?
    var snapped: Bool = false
    var touched: Bool = false
    var delegate: DynamicButtonProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        
        let gesture = UIPanGestureRecognizer(target: self, action: "longPress:")
        radius = self.frame.width/2 - 30
        numberOfPoints = 3
        centerPoint = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        calculateSnapPoints(numberOfPoints!)
        
        colors = [UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.grayColor()]
        let image = UIImage(named: "Button1.png")
        
        circle = UIView(frame: CGRect(x: 10, y: 10, width: 0, height: 0))
        circle?.center = centerPoint!
        circle?.backgroundColor = UIColor.clearColor()
        circle?.layer.borderColor = UIColor.blackColor().CGColor
        circle?.layer.borderWidth = 1
        self.addSubview(circle!)
        
        for var i = 0; i < Int(numberOfPoints!); i++ {
            
            let point = SnapPoint(frame: CGRect(x: (centerPoint?.x)!, y: (centerPoint?.y)!, width: 29, height: 29), color: colors[i]!, snap: snapPoints[i]!, image: image!)
            point.center = centerPoint!
            points.append(point)
            self.addSubview(points[i]!)
        }
        
        button = RoundedButton(frame: CGRect(x: 150, y: 220, width: 55, height: 55))
        button?.center = centerPoint!
        button?.addGestureRecognizer(gesture)
        button?.backgroundColor = UIColor.whiteColor()
        animator = UIDynamicAnimator(referenceView: self)
        
        snapBehavior = UISnapBehavior(item: button!, snapToPoint: centerPoint!)
        snapBehavior?.action = {self.button!.transform = CGAffineTransformIdentity}
        
        
        self.addSubview(button!)
    }
    
    func longPress(gesture: UIPanGestureRecognizer) {
        
        let panView = gesture.locationInView(self)
        let panButton = gesture.locationInView(self.button!)
        
        if gesture.state == .Began {
            
            animator?.removeAllBehaviors()
            
            let offset = UIOffsetMake(panButton.x - CGRectGetMidX((self.button?.bounds)!), panButton.y - CGRectGetMidY((self.button?.bounds)!))
            self.attachmentBehavior = UIAttachmentBehavior(item: self.button!, offsetFromCenter: offset, attachedToAnchor: panView)
            self.attachmentBehavior?.action = {self.button!.transform = CGAffineTransformIdentity}
            self.animator?.addBehavior(attachmentBehavior!)
        }
            
        else if gesture.state == .Changed {
            self.attachmentBehavior?.anchorPoint = panView
        }
            
        else if gesture.state == .Ended {
            
            getDistance(self.numberOfPoints!)
            animator?.removeAllBehaviors()
            animator?.addBehavior(snapBehavior!)
        }
    }
    
    func getDistance(numberOfPoints: CGFloat){
        
        for var count = 0; count < Int(numberOfPoints); count++ {
            
            let distance = sqrt(pow(((button?.center.x)! - (snapPoints[count]?.x)!), 2) + pow(((button?.center.y)! - (snapPoints[count]?.y)!), 2))
            if distance < 49 {
                
                if !snapped{self.button!.changeColor()}
                self.button!.updateImage(points[count]!.image!)
                self.snapBehavior?.snapPoint = snapPoints[count]!
                self.snapped = true
                self.delegate?.method(count)
                return
            }
        }
        
        self.touched = false
        self.minimize()
        if snapped{self.button!.normalPosition()}
        self.snapped = false
        self.snapBehavior?.snapPoint = self.centerPoint!
    }
    
    func calculateSnapPoints(numberOfPoints: CGFloat) {
        
        let angle = ((180/(numberOfPoints+1))) as CGFloat
        
        for var count = 0; count < Int(numberOfPoints); count++ {
            
            let x = (centerPoint?.x)! - cosd(CGFloat(count+1)*angle + CGFloat(count-1)*15)*radius!
            let y = (centerPoint?.y)! - sind(CGFloat(count+1)*angle + CGFloat(count-1)*15)*radius!
            
            self.snapPoints.append(CGPoint(x: x, y: y))
        }
    }
    
    func expand() {
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = self.radius!
        animation.duration = 0.2
        self.circle?.layer.cornerRadius = self.radius!
        self.circle?.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.circle?.frame.size.width += 2*self.radius!
            self.circle?.frame.size.height += 2*self.radius!
            self.circle?.frame.origin.x -= self.radius!
            self.circle?.frame.origin.y -= self.radius!
        })
        
        for var i = 0; i < Int(numberOfPoints!); i++ {
            
            UIView.animateWithDuration(0.2, delay: Double(i+1)*0.1, options: UIViewAnimationOptions.CurveLinear, animations: {
                
                self.points[i]?.center = (self.points[i]?.snap)!
                
                }, completion: nil)
        }
    }
    
    func minimize() {
        
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = self.radius!
        animation.toValue = 0
        animation.duration = 0.2
        self.circle?.layer.cornerRadius = 0
        self.circle?.layer.addAnimation(animation, forKey: "cornerRadius")
        
        UIView.animateWithDuration(0.2, animations: {
            
            self.circle?.frame.size.width -= 2*self.radius!
            self.circle?.frame.size.height -= 2*self.radius!
            self.circle?.frame.origin.x += self.radius!
            self.circle?.frame.origin.y += self.radius!
        })
        
        for var i = 0; i < Int(numberOfPoints!); i++ {
            
            UIView.animateWithDuration(0.2, delay: Double(i+1)*0.1, options: UIViewAnimationOptions.CurveLinear, animations: {
                
                self.points[i]?.center = self.centerPoint!
                
                }, completion: nil)
        }
    }
    
    func cosd(angle: CGFloat) -> CGFloat {
        
        return cos(angle * CGFloat((M_PI/180)))
    }
    
    func sind(angle: CGFloat) -> CGFloat {
        
        return sin(angle * CGFloat((M_PI/180)))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for t in touches {
            
            let location = t.locationInView(self)
            
            if CGRectContainsPoint((self.button?.frame)!, location) {
                
                touched = true
                
                if !snapped {self.expand()}
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !snapped && touched {self.minimize() ; touched = false}
    }
}