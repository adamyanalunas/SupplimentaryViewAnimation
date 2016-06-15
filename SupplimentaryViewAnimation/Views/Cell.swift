//
//  Cell.swift
//  SupplimentaryViewAnimation
//
//  Created by Adam Yanalunas on 6/14/16.
//  Copyright © 2016 Adam Yanalunas. All rights reserved.
//

import Foundation
import UIKit

class Cell: UICollectionViewCell {
    static let ID = "Cell"
    
    @IBOutlet weak var outline:UIView!
    
    override func awakeFromNib() {
        outline.layer.borderColor = UIColor(white: 0.8, alpha: 1).CGColor
        outline.layer.borderWidth = 1
    }
}