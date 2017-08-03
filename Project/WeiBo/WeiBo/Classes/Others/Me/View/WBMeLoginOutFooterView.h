//
//  WBMeLoginOutFooterView.h
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBMeLoginOutFooterView;

@protocol WBMeLoginOutFooterViewDelegate <NSObject>

@optional
- (void)footerViewDidClickLoginOut:(WBMeLoginOutFooterView *)footerView;

@end


@interface WBMeLoginOutFooterView : UIView

+ (__kindof WBMeLoginOutFooterView *)loginOutFooterView;
@property (nonatomic, weak) id<WBMeLoginOutFooterViewDelegate> delegate;

@end
