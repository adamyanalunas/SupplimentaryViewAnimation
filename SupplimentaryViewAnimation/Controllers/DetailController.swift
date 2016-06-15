//
//  DetailController.swift
//  SupplimentaryViewAnimation
//
//  Created by Adam Yanalunas on 6/15/16.
//  Copyright © 2016 Adam Yanalunas. All rights reserved.
//

import Foundation
import UIKit

protocol RowSelectable {
    func rowSelected(indexPath:NSIndexPath)
}

class DetailController:UIViewController {
    static let storyboardID = "DetailContainer"
    
    weak var collectionDelegate:CollectionController?
    weak var detailCollectionController:DetailCollectionViewController?
    weak var detailTableController:DetailTableViewController?
    
    private var neededHeight:CGFloat = 300
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        
        for childVC in childViewControllers {
            if childVC.isMemberOfClass(DetailTableViewController) {
                detailTableController = childVC as? DetailTableViewController
                detailTableController?.detailController = self
            } else if childVC.isMemberOfClass(DetailCollectionViewController) {
                detailCollectionController = childVC as? DetailCollectionViewController
                detailCollectionController?.detailController = self
            }
        }
    }
    
    func heightNeeded() -> CGFloat {
        return neededHeight
    }
}

extension DetailController: RowSelectable {
    func rowSelected(indexPath:NSIndexPath) {
        neededHeight = CGFloat(indexPath.row * 44 + 300)
        collectionDelegate?.shouldResizeDetail()
    }
}