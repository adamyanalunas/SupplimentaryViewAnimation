//
//  CollectionController.swift
//  SupplimentaryViewAnimation
//
//  Created by Adam Yanalunas on 6/14/16.
//  Copyright © 2016 Adam Yanalunas. All rights reserved.
//

import Foundation
import UIKit

protocol DetailResizable {
    func shouldResizeDetail()
}

private extension Selector {
    static let tapSelector = #selector(CollectionController.detailTapped(_:))
}

class CollectionController: UICollectionViewController {
    let cells = 10
    var detailController:DetailController?
    let layout = Layout()
    let sections = 1
    
    override func viewDidLoad() {
        collectionView?.registerClass(Supplimentary.self, forSupplementaryViewOfKind: Supplimentary.ID, withReuseIdentifier: Supplimentary.ID)
        
        layout.itemSize = CGSizeMake(145, 145);
        layout.minimumInteritemSpacing = 44;
        layout.minimumLineSpacing = 22;
        layout.sectionInset = UIEdgeInsetsMake(21, 21, 0, 0)
        
        self.collectionView?.collectionViewLayout = layout
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.ID, forIndexPath: indexPath)
//        if indexPath.item == 0 {
//            cell.backgroundColor = UIColor.greenColor()
//        } else if indexPath.item == 1 {
//            cell.backgroundColor = UIColor.redColor()
//        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementary = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Supplimentary.ID, forIndexPath: indexPath)
        
        supplementary.backgroundColor = UIColor.cyanColor()
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: .tapSelector)
//        tapGesture.numberOfTapsRequired = 1
//        supplementary.addGestureRecognizer(tapGesture)
        
        if let detailController = self.detailController {
            detailController.view.frame = supplementary.bounds
            supplementary.addSubview(detailController.view)
            
//            detailController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            detailController.view.translatesAutoresizingMaskIntoConstraints = false
            let views = ["detail": detailController.view]
            let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[detail]|", options: [], metrics: nil, views: views)
            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[detail]|", options: [], metrics: nil, views: views)
            supplementary.addConstraints(hConstraints)
            supplementary.addConstraints(vConstraints)
        }
        
        return supplementary
    }
    
    func detailTapped(gesture:UITapGestureRecognizer) {
        let heightNeeded:CGFloat
        if layout.detailViewSize.height == 300 {
            heightNeeded = 350
        } else {
            heightNeeded = 300
        }
        print("tap resize")
        layout.invalidateLayout()
        collectionView?.performBatchUpdates({
            self.layout.detailViewSize = CGSizeMake(0, heightNeeded)
            }, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        detailController?.view.layoutIfNeeded()
        collectionView.performBatchUpdates({
            if !self.layout.selected {
//                print("reveal")
                self.showDetail(indexPath)
                self.layout.selectedIndexPath = indexPath
                self.layout.selected = true
            } else {
//                print("hide")
                self.layout.selected = false
                self.hideDetail()
            }
            self.detailController?.view.layoutIfNeeded()
            }, completion: { (done) in
                self.layout.invalidateLayout()
        })
    }
    
    
    
    func showDetail(indexPath:NSIndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let detailController = sb.instantiateViewControllerWithIdentifier(DetailController.storyboardID) as? DetailController {
            addChildViewController(detailController)
            detailController.collectionDelegate = self
            self.detailController = detailController
        }
    }
    
    func hideDetail() {
        guard let detailController = self.detailController else { return }
        
        detailController.view.removeFromSuperview()
        detailController.removeFromParentViewController()
        self.detailController = nil
    }
}

extension CollectionController: DetailResizable {
    func shouldResizeDetail() {
        if let heightNeeded = self.detailController?.heightNeeded() {
            layout.invalidateLayout()
            collectionView?.performBatchUpdates({
                self.layout.detailViewSize = CGSizeMake(0, heightNeeded)
                }, completion: nil)
        }
    }
}