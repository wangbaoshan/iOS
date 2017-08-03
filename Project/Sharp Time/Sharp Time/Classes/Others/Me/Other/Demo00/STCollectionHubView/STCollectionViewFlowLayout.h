//
//  STCollectionViewFlowLayout.h
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STCollectionViewFlowLayout;

@protocol STCollectionViewFlowLayoutDelegate <NSObject>

@optional
- (void)collectionViewFlowLayout:(STCollectionViewFlowLayout *)flowLayout didScrollToItemIndex:(NSInteger)index;

@end

@interface STCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<STCollectionViewFlowLayoutDelegate> delegate;

@end
