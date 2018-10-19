//
//  AboutVCLayout.swift
//  CityGuide
//
//  Copyright © 2016 dmbTeam. All rights reserved.
//

import UIKit

protocol AboutVCLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath, withWidth:CGFloat) -> CGFloat
}

class AboutVCLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var photoHeight: CGFloat = 0.0
    
    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! AboutVCLayoutAttributes
        copy.photoHeight = photoHeight
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? AboutVCLayoutAttributes {
            if attributes.photoHeight == photoHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class AboutVCLayout: UICollectionViewLayout {

    var delegate: AboutVCLayoutDelegate!
    
    var numberOfColumns = 2
    var cellPadding: CGFloat = 6.0
    
    var cityInfoText = ""
    
    fileprivate var cache = [AboutVCLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat  = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override class var layoutAttributesClass : AnyClass {
        return AboutVCLayoutAttributes.self
    }
    
    override func prepare() {

        if cache.isEmpty {

            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                
                let font = UIFont(name: "Helvetica Light", size: 18)!
                let text = self.cityInfoText
                let textString = text as NSString
                let textAttributes = [NSAttributedStringKey.font: font]
                let textRect = textString.boundingRect(with: CGSize(width: contentWidth - cellPadding * 2, height: 2000), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
                
                let attributes = AboutVCLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = textRect.size.height
                attributes.frame = CGRect(x: cellPadding, y: cellPadding, width: textRect.size.width, height: textRect.size.height)
                cache.append(attributes)
                
                yOffset[0] = textRect.size.height
                yOffset[1] = textRect.size.height
            }
        
            for item in 0 ..< collectionView!.numberOfItems(inSection: 1) {
                
                let indexPath = IndexPath(item: item, section: 1)
                let width = columnWidth - cellPadding * 2
                let photoHeight = delegate.collectionView(collectionView!, heightForPhotoAtIndexPath: indexPath, withWidth:width)
                let height = cellPadding +  photoHeight + cellPadding
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = AboutVCLayoutAttributes(forCellWith: indexPath)
                attributes.photoHeight = photoHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                if column >= (numberOfColumns - 1) {
                    column = 0
                } else {
                  column += 1
                }
            }
        }
    }
    
    override var collectionViewContentSize : CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
