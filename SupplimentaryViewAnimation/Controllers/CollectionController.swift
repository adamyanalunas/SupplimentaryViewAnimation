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
    var badController:BadController?
    var goodController:UIViewController?
    let layout = Layout()
    
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
        return 10
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
        
        if let goodController = self.goodController {
            goodController.view.frame = supplementary.bounds
            supplementary.addSubview(goodController.view)
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
        let showWorking = firstCellPath.compare(indexPath) == .OrderedSame
        
        collectionView.performBatchUpdates({
            if !self.layout.selected {
                
                if showWorking {
                    self.showWorking()
                } else {
                    self.showBroken()
                }
                
                self.layout.selectedIndexPath = indexPath
                self.layout.selected = true
            } else {
                self.layout.selected = false
                self.hideWorking()
                self.hideBroken()
            }
            self.badController?.view.layoutIfNeeded()
            }, completion: { (done) in
                self.layout.invalidateLayout()
        })
    }
    
    func showBroken() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let badController = sb.instantiateViewControllerWithIdentifier(BadController.storyboardID) as? BadController {
            addChildViewController(badController)
            self.badController = badController
        }
    }
    
    func hideBroken() {
        guard let badController = self.badController else { return }
        
        badController.view.removeFromSuperview()
        badController.removeFromParentViewController()
        self.badController = nil
    }
    
    func showWorking() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let badController = sb.instantiateViewControllerWithIdentifier("SimplifiedViewController")
        addChildViewController(badController)
        self.goodController = badController
    }
    
    func hideWorking() {
        guard let goodController = self.goodController else { return }
        
        goodController.view.removeFromSuperview()
        goodController.removeFromParentViewController()
        self.goodController = nil
    }
}
