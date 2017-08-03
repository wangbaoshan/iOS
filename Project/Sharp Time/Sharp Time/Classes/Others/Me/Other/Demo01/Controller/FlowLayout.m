//
//  FlowLayout.m
//  Sharp Time
//
//  Created by power on 2017/7/15.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "FlowLayout.h"

/// 默认3列
#define kDefaultColumns 3

/// 默认水平间隙10.0f
#define kDefaultMinimumInteritemSpacing 10.0f

/// 默认垂直间隙10.0f
#define kDefaultMinimumLineSpacing 10.0f

/// 整体布局的边缘距离均为10.0f
#define kDefaultInset UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)

@interface FlowLayout ()

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation FlowLayout

#pragma mark - Getter

- (NSMutableArray<UICollectionViewLayoutAttributes *> *)attributesArray
{
    if (!_attributesArray) {
        _attributesArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attributesArray;
}

- (NSMutableArray<NSNumber *> *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray arrayWithCapacity:0];
    }
    return _columnHeights;
}

#pragma mark - Rewrite

- (void)prepareLayout
{
    [super prepareLayout];
    
    [self.columnHeights removeAllObjects];
    NSInteger columns = [self columns];
    for (int i = 0; i < columns; i++) {
        [self.columnHeights addObject:@(0)];
    }
    
    self.contentHeight = 0;
    [self.attributesArray removeAllObjects];
    NSInteger sections = [self.collectionView numberOfSections];
    for (int i = 0; i < sections; i++) {
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < items; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *att = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attributesArray addObject:att];
        }
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *att = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (!att) {
        att = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    }
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights.firstObject doubleValue];
    for (int i = 1; i < self.columnHeights.count; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight < minColumnHeight) {
            destColumn = i;
            minColumnHeight = columnHeight;
        }
    }
    
    UIEdgeInsets inset = [self inset];
    NSInteger columns = [self columns];
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacing];
    CGFloat minimumLineSpacing = [self minimumLineSpacing];
    
    CGFloat w = (self.collectionView.frame.size.width - inset.left - inset.right - (columns - 1) * minimumInteritemSpacing) / columns;
    CGFloat h = [self heightForIndexPath:indexPath itemWidth:w];
    CGFloat x = inset.left + (w + minimumInteritemSpacing) * destColumn;
    CGFloat y = 0;
    if (minColumnHeight == 0) {
        y = inset.top;
    } else {
        y = minColumnHeight + minimumLineSpacing;
    }
    
    att.frame = CGRectMake(x, y, w, h);
    
    CGFloat newColumnHeight = CGRectGetMaxY(att.frame);
    self.columnHeights[destColumn] = @(newColumnHeight);
    
    if (self.contentHeight < newColumnHeight) {
        self.contentHeight = newColumnHeight + inset.bottom;
    }
    
    return att;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

#pragma mark - Private

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    return [self.delegate flowLayout:self heightForItemAtIndexPath:indexPath itemWidth:itemWidth];
}

- (NSInteger)columns
{
    if ([self.delegate respondsToSelector:@selector(numberOfColumnsForFlowLayout:)]) {
        return [self.delegate numberOfColumnsForFlowLayout:self];
    } else {
        return kDefaultColumns;
    }
}

- (CGFloat)minimumInteritemSpacing
{
    if ([self.delegate respondsToSelector:@selector(minimumInteritemSpacingForFlowLayout:)]) {
        return [self.delegate minimumInteritemSpacingForFlowLayout:self];
    } else {
        return kDefaultMinimumInteritemSpacing;
    }
}

- (CGFloat)minimumLineSpacing
{
    if ([self.delegate respondsToSelector:@selector(minimumLineSpacingForFlowLayout:)]) {
        return [self.delegate minimumLineSpacingForFlowLayout:self];
    } else {
        return kDefaultMinimumLineSpacing;
    }
}

- (UIEdgeInsets)inset
{
    if ([self.delegate respondsToSelector:@selector(insetForFlowLayout:)]) {
        return [self.delegate insetForFlowLayout:self];
    } else {
        return kDefaultInset;
    }
}

@end
