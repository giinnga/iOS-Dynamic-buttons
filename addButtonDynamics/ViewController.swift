//
//  ViewController.swift
//  addButtonDynamics
//
//  Created by Victor Souza on 11/24/15.
//  Copyright © 2015 Victor Souza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DynamicButtonProtocol {
    
    var button: ButtonCapsule?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        button = ButtonCapsule(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        button?.delegate = self
        button?.center = CGPoint(x: CGRectGetMidX(self.view.bounds), y: CGRectGetMaxY(self.view.bounds) - 49)
//        button?.backgroundColor = UIColor.greenColor()
//        button?.userInteractionEnabled = true
        self.view.addSubview(button!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func method(count: Int) {
        print(count)
    }
}

