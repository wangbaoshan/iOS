//
//  STCollectionHubView.h
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCollectionHubView;
@class STCollectionViewCell;

@protocol STCollectionHubViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInCollectionHubView:(STCollectionHubView *)hubView;
- (STCollectionViewCell *)collectionHubView:(STCollectionHubView *)hubView cellForItemAtIndex:(NSInteger)index;

@end

@protocol STCollectionHubViewDelegate <NSObject>

@optional
- (void)collectionHubView:(STCollectionHubView *)hubView didSelectItemAtIndex:(NSInteger)index;
- (void)collectionHubView:(STCollectionHubView *)hubView didScrollToItemIndex:(NSInteger)index;

@end

@interface STCollectionHubView : UIView

/// item距离顶部的距离（默认为0）
@property (class, nonatomic, assign) CGFloat topMargin;
/// 缩放比例（设置范围在1.0-2.0之间有效，1.0不缩放，默认1.3）
@property (class, nonatomic, assign) CGFloat scale;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

@property (nonatomic, weak) id<STCollectionHubViewDataSource> dataSource;
@property (nonatomic, weak) id<STCollectionHubViewDelegate> delegate;

- (__kindof STCollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

@end
