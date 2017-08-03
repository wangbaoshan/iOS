//
//  WBReturnDefaultButton.m
//  WeiBo
//
//  Created by wbs on 17/2/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBReturnDefaultButton.h"

#define kReturnItemOriginalColor kCSSHexColor(@"#4C4C4C")
#define kReturnItemHighlightColor kCSSHexColor(@"#FF8200")

@interface WBReturnDefaultButton ()

@end

@implementation WBReturnDefaultButton

+ (WBReturnDefaultButton *)returnDefaultButtonWithTarget:(id)target title:(NSString *)title action:(SEL)action
{
    WBReturnDefaultButton *returnDefaultButton = [[self alloc] init];
    if (title) {
        [returnDefaultButton setTitle:title forState:UIControlStateNormal];
    }
    [returnDefaultButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return returnDefaultButton;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString *returnString = @"返回";
        [self setTitle:returnString forState:UIControlStateNormal];
        [self setTitleColor:kReturnItemOriginalColor forState:UIControlStateNormal];
        [self setTitleColor:kReturnItemHighlightColor forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"toolbar_leftarrow"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"toolbar_leftarrow_highlighted"] forState:UIControlStateHighlighted];
        self.titleLabel.font = kSystemNavigationItemFont;
        
        self.bounds = CGRectMake(0, 0, 100, 28);
        
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(28 - 12, 0, self.width - (28 - 12) , 28);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(-5, 0, 28, 28);
}

#pragma Private

- (CGSize)textSize:(NSString *)text
{
    return [text sizeWithAttributes:@{NSFontAttributeName : kSystemNavigationItemFont}];
}

@end
