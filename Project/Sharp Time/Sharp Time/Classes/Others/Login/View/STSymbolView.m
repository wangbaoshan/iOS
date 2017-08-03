//
//  STSymbolView.m
//  Sharp Time
//
//  Created by power on 2017/5/21.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STSymbolView.h"

@implementation STSymbolView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = kSystemNavigationItemNormalColor;
    
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.clipsToBounds = YES;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSString *str = @"Sharp Time";
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    // 文字范围内背景颜色
//    attr[NSBackgroundColorAttributeName] = [UIColor clearColor];
    
    // text color
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    // text font
    attr[NSFontAttributeName] = [UIFont systemFontOfSize:22];
    
    // 字间距
    attr[NSKernAttributeName] = @(0);
    
    // 文字段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    paraStyle.alignment = NSTextAlignmentCenter;
//    paraStyle.lineSpacing = 20;
    attr[NSParagraphStyleAttributeName] = paraStyle;
    
    // 设置文字描边，两句配合使用
    attr[NSStrokeColorAttributeName] = [UIColor whiteColor];
    attr[NSStrokeWidthAttributeName] = @(2.5);
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor purpleColor];
    shadow.shadowBlurRadius = 5;
    shadow.shadowOffset = CGSizeMake(5, 5);
    attr[NSShadowAttributeName] = shadow;
    attr[NSVerticalGlyphFormAttributeName] = @(0); // 0表示横排文本,1表示竖排文本
    
    CGSize size = [str sizeWithAttributes:attr];
    CGFloat x = (size.width > rect.size.width) ? 0 : (rect.size.width - size.width) * 0.5;
    CGFloat y = (size.height > rect.size.height) ? 0 : (rect.size.height - size.height) * 0.5;
    
    [str drawInRect:(CGRect){{x, y}, size} withAttributes:attr];
}


@end
