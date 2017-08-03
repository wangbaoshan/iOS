//
//  STMeFooterView.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STMeFooterView;

@protocol STMeFooterViewDelegate <NSObject>

@optional
- (void)footerView:(STMeFooterView *)footerView didClickLoginOutButton:(UIButton *)loginOutButton;

@end

@interface STMeFooterView : UIView

+ (__kindof STMeFooterView *)footerView;

@property (nonatomic, weak) id<STMeFooterViewDelegate> delegate;

@end
