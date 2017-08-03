//
//  WBHomeTitleButton.m
//  WeiBo
//
//  Created by wbs on 17/2/28.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeTitleButton.h"

@implementation WBHomeTitleButton

+ (WBHomeTitleButton *)titleButton
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 内部图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字对齐
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        // 文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 字体
        self.titleLabel.font = kSystemNavigationTitleFont;
        // 高亮的时候不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.height;
    CGFloat imageH = imageW;
    CGFloat imageX = self.bounds.size.width - imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleH = self.bounds.size.height;
    CGFloat titleW = self.bounds.size.width - self.bounds.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 1.计算文字的尺寸
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName : kSystemNavigationTitleFont}];
    
    // 2.计算按钮的宽度
    self.bounds = CGRectMake(0, 0, titleSize.width + self.bounds.size.height + 6, self.bounds.size.height);
}


@end
