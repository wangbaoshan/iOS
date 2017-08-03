//
//  STCollectionViewFlowLayout.m
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STCollectionViewFlowLayout.h"

#import "STCollectionHubView.h"


@interface STCollectionViewFlowLayout ()

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation STCollectionViewFlowLayout

/**
 *  重写这个方法让其滚动到最合适的中间位置
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGRect targetRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:targetRect];
    CGFloat centerX = self.collectionView.center.x;
    CGFloat proposedW = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        CGFloat centerM = centerX - (attribute.center.x - proposedContentOffset.x);
        if (fabs(centerM) <= proposedW) {
            proposedW = centerM;
        }
    }
    proposedContentOffset.x -= proposedW;
    return proposedContentOffset;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect targetRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    NSArray<__kindof UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:targetRect];
    NSArray<__kindof UICollectionViewLayoutAttributes *> *newAttributes = [[NSArray alloc] initWithArray:attributes copyItems:YES];
    CGFloat centerX = self.collectionView.center.x;
    for (UICollectionViewLayoutAttributes *attribute in newAttributes) {
        // 获得距离中心的距离
        CGFloat centerM = fabs(centerX - (attribute.center.x - self.collectionView.contentOffset.x));
        CGFloat scale = 1.0 - centerM / centerX;
        
        attribute.transform = CGAffineTransformMakeScale(1 + ([STCollectionHubView scale] - 1) * scale, 1 + ([STCollectionHubView scale] - 1) * scale);
        
        if (scale < 0.5) {
            attribute.alpha = 0.5;
        } else if (scale > 0.99) {
            attribute.alpha = 1.0;
        } else {
            attribute.alpha = scale;
        }
        
    }
    return newAttributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGPoint point = [self.collectionView.superview convertPoint:self.collectionView.center toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (!indexPath) return YES;
    
    if (indexPath.item != self.currentIndexPath.item) {
        if ([self.delegate respondsToSelector:@selector(collectionViewFlowLayout:didScrollToItemIndex:)]) {
            [self.delegate collectionViewFlowLayout:self didScrollToItemIndex:indexPath.item];
            self.currentIndexPath = indexPath;
        }
    }
    return YES;
}

@end
