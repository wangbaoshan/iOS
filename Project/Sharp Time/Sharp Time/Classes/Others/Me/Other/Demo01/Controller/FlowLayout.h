//
//  FlowLayout.h
//  Sharp Time
//
//  Created by power on 2017/7/15.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlowLayout;

@protocol FlowLayoutDelegate <NSObject>

@required
/// 每个item的高度
- (CGFloat)flowLayout:(FlowLayout *)flowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/// 展示的列数
- (NSInteger)numberOfColumnsForFlowLayout:(FlowLayout *)flowLayout;
/// item间的水平间隙
- (CGFloat)minimumLineSpacingForFlowLayout:(FlowLayout *)flowLayout;
/// item间的垂直间隙
- (CGFloat)minimumInteritemSpacingForFlowLayout:(FlowLayout *)flowLayout;
/// 整体布局的inset
- (UIEdgeInsets)insetForFlowLayout:(FlowLayout *)flowLayout;

@end

@interface FlowLayout : UICollectionViewFlowLayout

/// delegate
@property (nonatomic, weak) id<FlowLayoutDelegate> delegate;

@end
