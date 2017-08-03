//
//  WBTabBar.h
//  WeiBo
//
//  Created by wbs on 17/2/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBTabBar;

@protocol WBTabBarDelegate <UITabBarDelegate>

@optional
- (void)tabBar:(WBTabBar *)tabBar didClickPlusButton:(UIButton *)plusButton;

@end

@interface WBTabBar : UITabBar

@property (nonatomic, weak) id<WBTabBarDelegate> delegate;

@end
