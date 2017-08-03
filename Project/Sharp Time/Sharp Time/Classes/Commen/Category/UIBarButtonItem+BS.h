//
//  UIBarButtonItem+BS.h
//  hindi4iOS
//
//  Created by 王宝山 on 16/7/30.
//  Copyright © 2016年 onairm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BS)

/** 根据图片返回一个自定义的UIBarButtonItem */
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action;

/** 根据文字返回一个自定义的UIBarButtonItem */
+ (UIBarButtonItem *)itemWithName:(NSString *)name font:(UIFont *)font normalTextColor:(UIColor *)normalTextColor highlightTextColor:(UIColor *)highlightTextColor target:(id)target action:(SEL)action;

@end
