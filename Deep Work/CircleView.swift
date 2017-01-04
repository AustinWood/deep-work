//
//  CircleView.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-11.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    func setBackgroundColor(color: UIColor) {
        self.backgroundColor = color
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2.0
        drawGrayBorder()
    }
    
    //////////////////////////////////////////////
    // MARK:- Circle Border
    
    // Reference: http://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle
    
    let borderWidth: CGFloat = 1.0
    
    func drawGrayBorder() {
        removeGrayBorders()
        drawBorder(fillPercent: 1.0, color: CustomColor.gray, animated: false)
    }
    
    func drawBorder(fillPercent: CGFloat, color: UIColor, animated: Bool) {
        self.layoutIfNeeded()
        var borderLayer: CAShapeLayer!
        //let borderRadius = (self.frame.size.width + borderWidth/2)/2 // ORIGINAL
        //let borderRadius = (self.frame.size.width)/2 // also works
        let borderRadius = (self.frame.size.width - borderWidth/2)/2 // best?
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: borderRadius, startAngle: CGFloat(M_PI * -0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        borderLayer = CAShapeLayer()
        borderLayer.path = circlePath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = borderWidth
        if animated {
            borderLayer.name = "animatedBorder"
        } else {
            borderLayer.name = "staticBorder"
        }
        if animated {
            borderLayer.strokeEnd = 0.0
            layer.addSublayer(borderLayer)
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = 1.1
            animation.fromValue = 0
            animation.toValue = fillPercent
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            borderLayer.strokeEnd = fillPercent
            borderLayer.add(animation, forKey: "animateCircle")
        } else {
            borderLayer.strokeEnd = fillPercent
            layer.addSublayer(borderLayer)
        }
    }
    
    func removeBorders() {
        for layer in self.layer.sublayers! {
            if layer.name == "animatedBorder" {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    func removeGrayBorders() {
        for layer in self.layer.sublayers! {
            if layer.name == "staticBorder" {
                layer.removeFromSuperlayer()
            }
        }
    }
    
//    func animateBackground(duration: TimeInterval, backgroundColor: UIColor) {
//        UILabel.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {() -> Void in
//            self.backgroundColor = backgroundColor
//        }, completion: {(finished: Bool) -> Void in
//            // Completed animation
//        })
//    }
    
}
