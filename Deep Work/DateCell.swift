//
//  DateCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-20.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
}
