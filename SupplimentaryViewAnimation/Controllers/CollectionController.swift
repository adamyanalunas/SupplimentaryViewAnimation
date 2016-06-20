//
//  CollectionController.swift
//  SupplimentaryViewAnimation
//
//  Created by Adam Yanalunas on 6/14/16.
//  Copyright © 2016 Adam Yanalunas. All rights reserved.
//

import Foundation
import UIKit

private extension Selector {
    static let tapSelector = #selector(CollectionController.supplementaryTapped(_:))
}

class CollectionController: UICollectionViewController {
    let cells = 10
    var badController:BadController?
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
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.ID, forIndexPath: indexPath)
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.greenColor()
        } else if indexPath.item == 1 {
            cell.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let supplementary = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Supplimentary.ID, forIndexPath: indexPath)
        
        let tap = UITapGestureRecognizer(target: self, action: .tapSelector)
        supplementary.addGestureRecognizer(tap)
        supplementary.backgroundColor = UIColor.cyanColor()
        
        if let badController = self.badController {
            badController.view.frame = supplementary.bounds
            supplementary.addSubview(badController.view)
        }
        
        if let minimalController = self.minimalController {
            minimalController.view.frame = supplementary.bounds
            supplementary.addSubview(minimalController.view)
        }
        
        return supplementary
    }
    
    func supplementaryTapped(gesture:UITapGestureRecognizer) {
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
        badController?.view.layoutIfNeeded()
        
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
            self.badController?.view.layoutIfNeeded()
            }, completion: { (done) in
                self.layout.invalidateLayout()
        })
    }
    
    func showDetail() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let badController = sb.instantiateViewControllerWithIdentifier(BadController.storyboardID) as? BadController {
            addChildViewController(badController)
            self.badController = badController
        }
    }
    
    func hideDetail() {
        guard let badController = self.badController else { return }
        
        badController.view.removeFromSuperview()
        badController.removeFromParentViewController()
        self.badController = nil
    }
    
    func showMinimal() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let badController = sb.instantiateViewControllerWithIdentifier("SimplifiedViewController")
        addChildViewController(badController)
        self.minimalController = badController
    }
    
    func hideMinimal() {
        guard let minimalController = self.minimalController else { return }
        
        minimalController.view.removeFromSuperview()
        minimalController.removeFromParentViewController()
        self.minimalController = nil
    }
}
