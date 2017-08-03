//
//  STTitleButton.m
//  Sharp Time
//
//  Created by power on 2017/5/10.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STTitleButton.h"

@interface STTitleButton ()

@property (nonatomic, assign) CGFloat constHeight;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat sideMargin;

@end

#define kDefaultMixWidth 40.0f

@implementation STTitleButton

+ (STTitleButton *)titleButtonWithConstHeight:(CGFloat)height maxWidth:(CGFloat)maxWidth sideMargin:(CGFloat)sideMargin font:(UIFont *)font
{
    return [[self alloc] initWithConstHeight:height maxWidth:maxWidth sideMargin:sideMargin font:font];
}

- (instancetype)initWithConstHeight:(CGFloat)height maxWidth:(CGFloat)maxWidth sideMargin:(CGFloat)sideMargin font:(UIFont *)font
{
    self = [super init];
    if (self) {
        self.constHeight = height;
        self.maxWidth = maxWidth;
        self.sideMargin = sideMargin;
        self.titleLabel.font = font;
        self.frame = CGRectMake(0, 0, kDefaultMixWidth, height);
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGFloat w = ((size.width + self.sideMargin * 2) <= kDefaultMixWidth) ? kDefaultMixWidth : MIN(size.width + self.sideMargin * 2, [UIScreen mainScreen].bounds.size.width);
    self.frame = CGRectMake(0, 0, w, self.constHeight);
}

@end
