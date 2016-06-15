//
//  Layout.swift
//  SupplimentaryViewAnimation
//
//  Created by Adam Yanalunas on 6/14/16.
//  Copyright © 2016 Adam Yanalunas. All rights reserved.
//

import Foundation
import UIKit

class Layout:UICollectionViewFlowLayout {
    var detailViewSize = CGSizeMake(100, 300)
    var selected:Bool = false
    var selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0)
    
    private var selectedTopOffset:CGFloat = 0
    
    override class func layoutAttributesClass() -> AnyClass {
        return LayoutAttributes.self
    }
    
    override init() {
        super.init()
        selected = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selected = false
    }
    
    func selectionLayoutAttributes(layoutAttributes:UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let isSelectedPath = layoutAttributes.indexPath.compare(selectedIndexPath) == .OrderedSame
        let isAfterSelected = layoutAttributes.indexPath.compare(selectedIndexPath) == .OrderedDescending
        let isCellType = layoutAttributes.representedElementCategory == .Cell;
        let isDifferentRow = CGRectGetMinY(layoutAttributes.frame) > selectedTopOffset;
        let shouldPushDown = isAfterSelected && isDifferentRow;
        
        let layoutAttributesCopy = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        
        if selected && isSelectedPath && isCellType
        {
            selectedTopOffset = CGRectGetMinY(layoutAttributes.frame);
            var frame = layoutAttributes.frame;
            frame.size.height += detailViewSize.height;
            layoutAttributesCopy.frame = frame;
            
//            layoutAttributes.selected = true;
        }
        else if selected && shouldPushDown
        {
            var frame = layoutAttributes.frame;
            frame.origin.y += detailViewSize.height;
            layoutAttributesCopy.frame = frame;
        }
        
        return layoutAttributesCopy;
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let allAttributes = super.layoutAttributesForElementsInRect(rect) else { return nil }
        var attributes = [UICollectionViewLayoutAttributes]()
        attributes = allAttributes.map {
            selectionLayoutAttributes($0)
        }
        
        if selected {
            if let suppAttributes = layoutAttributesForSupplementaryViewOfKind(Supplimentary.ID, atIndexPath: selectedIndexPath) {
                attributes.append(suppAttributes)
            }
        }
        
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItemAtIndexPath(indexPath) else { return nil }
        return selectionLayoutAttributes(attributes)
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = LayoutAttributes(forSupplementaryViewOfKind: elementKind, withIndexPath: indexPath)
        if elementKind == Supplimentary.ID {
            if let cellAttributes = self.layoutAttributesForItemAtIndexPath(indexPath), let collectionView = collectionView {
                var frame = cellAttributes.frame
                let spaceFromCellTop = itemSize.height
                
                frame.origin.x = 0 - collectionView.contentInset.left;
                frame.origin.y += spaceFromCellTop;
                frame.size.height = detailViewSize.height;
                frame.size.width = CGRectGetWidth(collectionView.frame);
                
                attributes.frame = frame;
            }
        }
        
        return attributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        var size = super.collectionViewContentSize()
        if selected {
            size.height += detailViewSize.height
        }
        
        return size
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !CGRectEqualToRect(newBounds, collectionView.frame)
    }
}