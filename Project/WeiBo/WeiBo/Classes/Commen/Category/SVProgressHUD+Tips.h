//
//  SVProgressHUD+Tips.h
//  WeiBo
//
//  Created by wbs on 17/3/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "SVProgressHUD.h"

@interface SVProgressHUD (Tips)

// 以下常有方法默认加到窗口上，默认SVProgressHUDAnimationTypeFlat样式
+ (void)showLoading;
+ (void)showLoadingTips:(NSString *)message;
+ (void)showSuccessTips:(NSString *)message;
+ (void)showErrorTips:(NSString *)message;
+ (void)dismissTips;

@end
