//
//  WBHomeMenuButton.m
//  WeiBo
//
//  Created by wbs on 17/3/8.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeMenuButton.h"

@interface WBHomeMenuButton ()

@property (nonatomic, copy) NSString *text;

@end

static CGFloat const margin = 5.0;

@implementation WBHomeMenuButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.cornerRadius = 2.0;
        self.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeLeft;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:kCSSHexColor(@"#FFA500") forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageWithColor:kCSSHexColor(@"#383838") alpha:1.0] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageWithColor:kCSSHexColor(@"#7A7A7A") alpha:1.0] forState:UIControlStateSelected];
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGSize size = [self textSize];
    CGFloat width = (size.width > self.width - self.height - margin * 2) ? self.width - self.height - margin * 2 : size.width;
    return CGRectMake(margin, 0, width, self.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = [self textSize];
    CGFloat x = (size.width > self.width - self.height - margin * 2) ? self.width - self.height - margin * 2 : size.width + margin * 2;
    return CGRectMake(x, 0, self.height, self.height);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    self.text = [title copy];
}


#pragma Private

- (CGSize)textSize
{
    return [self.text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]}];
}

@end
