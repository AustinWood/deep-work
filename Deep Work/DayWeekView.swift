//
//  DayWeekButton.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-18.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class DayWeekView: UIView {
    
    ////////////////////////////////////////
    // Style the border and rounding when view first loads
    
    override func awakeFromNib() {
        layer.cornerRadius = 10
        self.backgroundColor = UIColor.black
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
    ////////////////////////////////////////
    // Refresh style depending on whether 'Today' or 'This week' is selected
    
    func isSelected() {
        self.backgroundColor = CustomColor.blueGreen
        layer.borderColor = CustomColor.whiteSmoke.cgColor
        setTextColor(color: CustomColor.whiteSmoke)
    }
    
    func isNotSelected() {
        self.backgroundColor = UIColor.black
        layer.borderColor = CustomColor.ashGrey.cgColor
        setTextColor(color: CustomColor.ashGrey)
    }
    
    ////////////////////////////////////////
    // Format the labels
    
    func setTextColor(color: UIColor) {
        let subLabels = getLabelsInView(self)
        for label in subLabels {
            label.textColor = color
        }
    }
    
    func getLabelsInView(_ view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(subview)
            }
        }
        return results
    }
    
}
