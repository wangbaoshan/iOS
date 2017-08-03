//
//  SVProgressHUD+Tips.m
//  WeiBo
//
//  Created by wbs on 17/3/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "SVProgressHUD+Tips.h"

static CGFloat const kMinimumDismissTimeInterval = 1.5f;

@implementation SVProgressHUD (Tips)

+ (void)showLoading;
{
    [self baseSetting];
    [SVProgressHUD show];
}
+ (void)showLoadingTips:(NSString *)message
{
    [self baseSetting];
    [SVProgressHUD showWithStatus:message];
}
+ (void)showSuccessTips:(NSString *)message
{
    [self baseSetting];
    [SVProgressHUD showSuccessWithStatus:message];
}
+ (void)showErrorTips:(NSString *)message
{
    [self baseSetting];
    [SVProgressHUD showErrorWithStatus:message];
}
+ (void)dismissTips
{
    [SVProgressHUD dismiss];
}

#pragma mark - Base Setting

+ (void)baseSetting
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:kMinimumDismissTimeInterval];
}

@end
