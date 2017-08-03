//
//  WBMeHeaderView.h
//  WeiBo
//
//  Created by wbs on 17/3/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBMeHeaderView;

typedef enum : NSUInteger {
    WBMeHeaderViewClickTypeMeDetail = 10,
    WBMeHeaderViewClickTypeStatus,
    WBMeHeaderViewClickTypeAttention,
    WBMeHeaderViewClickTypeFuns
} WBMeHeaderViewClickType;

@protocol WBMeHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(WBMeHeaderView *)headerView didClickType:(WBMeHeaderViewClickType)type;

@end

@class WBUser;

@interface WBMeHeaderView : UIView

+ (__kindof WBMeHeaderView *)headerView;

@property (nonatomic, strong) WBUser *user;
@property (nonatomic, weak) id<WBMeHeaderViewDelegate> delegate;

@end


@interface WBMeHeaderViewLabel : UILabel

@property (nonatomic, copy) NSString *baseString;

@end
