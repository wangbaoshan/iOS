//
//  UIBarButtonItem+BS.m
//  hindi4iOS
//
//  Created by 王宝山 on 16/7/30.
//  Copyright © 2016年 onairm. All rights reserved.
//

#import "UIBarButtonItem+BS.h"

@implementation UIBarButtonItem (BS)

+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    
    // 设置按钮的尺寸为背景图片的尺寸
    CGSize size = button.currentBackgroundImage.size;
    button.bounds = CGRectMake(0, 0, size.width, size.height);
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
