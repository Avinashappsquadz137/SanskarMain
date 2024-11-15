//
//  ZoonAndSnapLayout.swift
//  Sanskar
//
//  Created by Warln on 07/02/22.
//  Copyright © 2022 MAC MINI. All rights reserved.
//

import UIKit

class ZoonAndSnapLayout: UICollectionViewFlowLayout {
    
    let activeDistance: CGFloat = 200
    let zoomFactor: CGFloat = 0.3
    
    override init() {
        super.init()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 40
        itemSize = CGSize(width: 200, height: 100)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder): is not impelemneted")
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else { fatalError() }
        let verticalInset = (collectionView.frame.height -  collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom - itemSize.height) / 2
        let horizontalInset = (collectionView.frame.width - collectionView.adjustedContentInset.right - collectionView.adjustedContentInset.left - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        super.prepare()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let collectionView = collectionView else { return nil }
        let rectAttributes = super.layoutAttributesForElements(in: rect)!.map { $0.copy() as! UICollectionViewLayoutAttributes}
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)
        
        //Make cell zoom when they reach to the center
        for attributes in rectAttributes where attributes.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - attributes.center.x
            let normalizeDistance = distance / activeDistance
            
            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomFactor * (1 - normalizeDistance.magnitude)
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                attributes.zIndex = Int(zoom.rounded())
            }
            
        }
        return rectAttributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else { return .zero }
        //Add some snapping behaviour so that some zoom cell is always in center
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let rectAttributes = super.layoutAttributesForElements(in: targetRect) else { return .zero }
        var offSetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + collectionView.frame.width / 2
        
        for layoutAttributes in rectAttributes {
            let itemHorizontalCenter = layoutAttributes.center.x
            if (itemHorizontalCenter - horizontalCenter).magnitude < offSetAdjustment.magnitude {
                offSetAdjustment = itemHorizontalCenter - horizontalCenter
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offSetAdjustment, y: proposedContentOffset.y)
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every that every cell get the chance to zoom when in center
        
        return true
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewLayoutInvalidationContext
//        context.invalidateFlowLayoutDelegateMetrics
        return context
    }

}
