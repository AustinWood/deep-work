//
//  HomeBottomView.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-25.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit
import QuartzCore

class BorderView: UIView {
    
//    let borderHeight = 5.0 as CGFloat
//    let borderColor = CustomColor.red.cgColor
//    //let borderHeight = 1.0 as CGFloat
//    //let borderColor = CustomColor.gray.cgColor
//    
//    override func awakeFromNib() {
//        self.backgroundColor = CustomColor.dark1
//    }
//    
//    func addTopBorder() {
//        let TopBorder = CALayer()
//        TopBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: borderHeight)
//        TopBorder.backgroundColor = borderColor
//        self.layer.addSublayer(TopBorder)
//    }
//    
//    func addBottomBorder() {
//        print("add BOTTOM border")
//        let TopBorder = CALayer()
//        TopBorder.frame = CGRect(x: 0.0, y: (self.frame.size.height - borderHeight), width: self.frame.size.width, height: borderHeight)
//        TopBorder.backgroundColor = borderColor
//        self.layer.addSublayer(TopBorder)
//    }
    
    
    
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.white, thickness: CGFloat = 1) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                                               options: [],
                                                               metrics: ["thickness": thickness],
                                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                                               options: [],
                                                               metrics: nil,
                                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        for border in borders {
            self.addSubview(border)
        }
        
        
        return borders
        
    }
    
    
    func addTopBorder() {
        self.addBorder(edges: [.top], colour: UIColor.green) // Just Top, green, default thickness
    }
    
    func addBottomBorder() {
        self.addBorder(edges: [.bottom], colour: UIColor.green) // Just Top, green, default thickness
    }

// Usage:         
//container.addBorder(edges: [.All]) // All with default arguments

//container.addBorder(edges: [.Left, .Right, .Bottom], colour: UIColor.redColor(), thickness: 3) // All except Top, red, thickness 3
    
}
