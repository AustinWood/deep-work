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
    
    //////////////////////////////////////////////
    // MARK:- Circle Border
    
    // Reference: http://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle
    
    let borderWidth: CGFloat = 1.0
    
    func drawBorder(fillPercent: CGFloat) {
        createLayer(fillPercent: 1.0, color: CustomColor.gray, animated: false)
        createLayer(fillPercent: fillPercent, color: CustomColor.pinkHot, animated: true)
    }
    
    func createLayer(fillPercent: CGFloat, color: UIColor, animated: Bool) {
        var borderLayer: CAShapeLayer!
        let borderRadius = (self.frame.size.width + borderWidth/2)/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: borderRadius, startAngle: CGFloat(M_PI * -0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        borderLayer = CAShapeLayer()
        borderLayer.path = circlePath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = color.cgColor
        borderLayer.lineWidth = borderWidth
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
    
}
