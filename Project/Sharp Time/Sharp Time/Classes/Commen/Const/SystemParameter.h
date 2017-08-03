//
//  SystemParameter.h
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//  基础宏定义

#ifndef SystemParameter_h
#define SystemParameter_h

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kTabBarHeight 49.0
#define kNavBarHeight 44.0
#define kStatusBarHeight 20.0
#define kNavBarAddStatusBarHeight 64.0

#define kIS_IPHONE6P_6SP_7P  (736.0 == kScreenHeight)
#define kIS_IPHONE6_6S_7     (667.0 == kScreenHeight)
#define kIS_IPHONE5_5S_5C_SE (568.0 == kScreenHeight)
#define kIS_IPHONE4_4S       (480.0 == kScreenHeight)

#define kIS_IOS7  ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define kIS_IOS8  ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define kIS_IOS9  ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)
#define kIS_IOS10 ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)

#endif /* SystemParameter_h */
