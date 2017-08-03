//
//  STCollectionView.m
//  Sharp Time
//
//  Created by power on 2017/6/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STCollectionView.h"

@implementation STCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = 0.0;
    }
    return self;
}


@end
