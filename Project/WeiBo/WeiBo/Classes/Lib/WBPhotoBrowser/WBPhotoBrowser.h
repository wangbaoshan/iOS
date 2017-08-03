//
//  WBPhotoBrowser.h
//  WeiBo
//
//  Created by wbs on 17/2/21.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kWBPhotoBrowserShouldHideStatusBar;
UIKIT_EXTERN NSString *const kWBPhotoBrowserShouldNotHideStatusBar;

@class WBPhoto;

@interface WBPhotoBrowser : UIView

+ (__kindof WBPhotoBrowser *)browser;

@property (nonatomic, strong) NSArray<WBPhoto *> *photos;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat minimumLineSpacing;

- (void)show;

@end
