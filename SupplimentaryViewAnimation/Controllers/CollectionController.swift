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
    var minimalController:UIViewController?
    var minimalTapGesture:UITapGestureRecognizer?
    let sections = 1
    
    override func viewDidLoad() {
        guard let collectionView = collectionView else { return }
        collectionView.registerClass(Supplimentary.self, forSupplementaryViewOfKind: Supplimentary.ID, withReuseIdentifier: Supplimentary.ID)
        
        layout.itemSize = CGSizeMake(145, 145);
        layout.minimumInteritemSpacing = 44;
        layout.minimumLineSpacing = 22;
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20)
        
        collectionView.collectionViewLayout = layout
        selectCell(NSIndexPath(forItem: 0, inSection: 0), collectionView: collectionView)
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
        
        if let detailController = self.detailController {
            detailController.view.frame = supplementary.bounds
            supplementary.addSubview(detailController.view)
            
//            detailController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//            detailController.view.translatesAutoresizingMaskIntoConstraints = false
//            let views = ["detail": detailController.view]
//            let hConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[detail]|", options: [], metrics: nil, views: views)
//            let vConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[detail]|", options: [], metrics: nil, views: views)
//            supplementary.addConstraints(hConstraints)
//            supplementary.addConstraints(vConstraints)
        }
        
        if let minimalController = self.minimalController {
            self.minimalTapGesture = UITapGestureRecognizer(target: self, action: .tapSelector)
            self.minimalTapGesture!.numberOfTapsRequired = 1
            supplementary.addGestureRecognizer(self.minimalTapGesture!)
            
            minimalController.view.frame = supplementary.bounds
            supplementary.addSubview(minimalController.view)
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
        
        layout.invalidateLayout()
        collectionView?.performBatchUpdates({
            self.layout.detailViewSize = CGSizeMake(0, heightNeeded)
            }, completion: nil)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectCell(indexPath, collectionView: collectionView)
    }
    
    func selectCell(indexPath:NSIndexPath, collectionView:UICollectionView) {
        detailController?.view.layoutIfNeeded()
        
        let firstCellPath = NSIndexPath(forItem: 0, inSection: 0)
        let useMinimal = firstCellPath.compare(indexPath) == .OrderedSame
        
        collectionView.performBatchUpdates({
            if !self.layout.selected {
                
                if useMinimal {
                    self.showMinimal()
                } else {
                    self.showDetail()
                }
                
                self.layout.selectedIndexPath = indexPath
                self.layout.selected = true
            } else {
                self.layout.selected = false
                
                if useMinimal {
                    self.hideMinimal()
                } else {
                    self.hideDetail()
                }
            }
            self.detailController?.view.layoutIfNeeded()
            }, completion: { (done) in
                self.layout.invalidateLayout()
        })
    }
    
    func showDetail() {
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
    
    func showMinimal() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailController = sb.instantiateViewControllerWithIdentifier("SimplifiedViewController")
        addChildViewController(detailController)
        self.minimalController = detailController
    }
    
    func hideMinimal() {
        guard let minimalController = self.minimalController else { return }
        
        minimalController.view.removeFromSuperview()
        minimalController.removeFromParentViewController()
        self.minimalController = nil
    }
}

extension CollectionController: DetailResizable {
    func shouldResizeDetail() {
//        if let heightNeeded = self.detailController?.heightNeeded() {
//            layout.invalidateLayout()
//            collectionView?.performBatchUpdates({
//                self.layout.detailViewSize = CGSizeMake(0, heightNeeded)
//                }, completion: nil)
//        }
    }
}