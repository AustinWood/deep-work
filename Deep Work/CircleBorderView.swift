//
//  AnimatedCircleView.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-26.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

// Reference:
// http://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle

import UIKit

class CircleBorderView: UIView {
    
    var circleLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        

    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.clear
//        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - 10)/2, startAngle: CGFloat(M_PI * -0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
//        
//        // Setup the CAShapeLayer with the path, colors, and line width
//        circleLayer = CAShapeLayer()
//        circleLayer.path = circlePath.cgPath
//        circleLayer.fillColor = UIColor.clear.cgColor
//        circleLayer.strokeColor = CustomColor.pinkHot.cgColor
//        circleLayer.lineWidth = 5.0
//        
//        // Don't draw the circle initially
//        circleLayer.strokeEnd = 0.0
//        
//        // Add the circleLayer to the view's layer's sublayers
//        layer.addSublayer(circleLayer)
//    }
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func animateCircle(fillPercent: CGFloat) {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        // from override init
        //let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 10, startAngle: CGFloat(M_PI * -0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        
        let borderWidth: CGFloat = 1.0
        //let borderRadius = (frame.size.width - borderWidth/2)/2
        let borderRadius = (frame.size.width)/2
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: borderRadius, startAngle: CGFloat(M_PI * -0.5), endAngle: CGFloat(M_PI * 1.5), clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = CustomColor.pinkHot.cgColor
        circleLayer.lineWidth = borderWidth
        
        // Don't draw the circle initially
        //circleLayer.strokeEnd = 0.0
        circleLayer.strokeEnd = fillPercent
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
        
//        print("Animate!")
//        let duration: TimeInterval = 1.0
//        // We want to animate the strokeEnd property of the circleLayer
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        
//        // Set the animation duration appropriately
//        animation.duration = duration
//        
//        // Animate from 0 (no circle) to 1 (full circle)
//        animation.fromValue = 0
//        animation.toValue = fillPercent
//        
//        // Do a linear animation (i.e. the speed of the animation stays the same)
//        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
//        
//        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
//        // right value when the animation ends.
//        circleLayer.strokeEnd = fillPercent
//        
//        // Do the actual animation
//        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    
}
