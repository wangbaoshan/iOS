//
//  WBStatusToolBar.h
//  WeiBo
//
//  Created by wbs on 17/2/27.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBStatus;
@class WBStatusToolBar;

typedef enum : NSUInteger {
    WBStatusToolBarTypeRetweet,
    WBStatusToolBarTypeComment,
    WBStatusToolBarTypePraise
} WBStatusToolBarType;

@protocol WBStatusToolBarDelegate <NSObject>

@optional
- (void)statusToolBar:(WBStatusToolBar *)toolBar didClickBtnType:(WBStatusToolBarType)type;

@end

@interface WBStatusToolBar : UIView

+ (__kindof WBStatusToolBar *)statusToolBar;

@property (nonatomic, strong) WBStatus *status;

@end
