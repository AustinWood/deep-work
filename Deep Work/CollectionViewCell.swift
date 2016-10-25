//
//  CollectionViewCell.swift
//  Deep Work
//
//  Created by Austin Wood on 2016-10-24.
//  Copyright © 2016 Austin Wood. All rights reserved.
//

    import UIKit

    class CollectionViewCell: UICollectionViewCell {
    
        var initialLoad = true
    
        internal func configureCell() {
        
            if initialLoad {
                // set your image here
            }
        
            initialLoad = false
        
            // do everything else here
        }
    
    }
