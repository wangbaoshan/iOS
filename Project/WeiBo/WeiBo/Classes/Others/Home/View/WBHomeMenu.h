//
//  WBHomeMenu.h
//  WeiBo
//
//  Created by wbs on 17/3/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBHomeMenuGroup;

typedef enum : NSUInteger {
    WBHomeMenuAlignmentTypeCenter = 0,
    WBHomeMenuAlignmentTypeLeft,
    WBHomeMenuAlignmentTypeRight
} WBHomeMenuAlignmentType;

@interface WBHomeMenu : UIView

@property (nonatomic, assign) WBHomeMenuAlignmentType alignmentType;
@property (nonatomic, copy) NSArray<WBHomeMenuGroup *> *groups;

@property (nonatomic, strong) NSIndexPath *defaultSelectedIndexPath;

+ (__kindof WBHomeMenu *)menu;
- (void)show;

@end


