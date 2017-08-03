//
//  STMeHeaderView.h
//  Sharp Time
//
//  Created by power on 2017/5/18.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfo;
@class STMeHeaderView;

@protocol STMeHeaderViewDelegate <NSObject>

@optional
- (void)headerView:(STMeHeaderView *)headerView didClickIconView:(UIImageView *)iconView;

@end

@interface STMeHeaderView : UIView

+ (__kindof STMeHeaderView *)headerView;

@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, weak) id<STMeHeaderViewDelegate> delegate;

@end


@interface STIconImageView : UIImageView

@end
