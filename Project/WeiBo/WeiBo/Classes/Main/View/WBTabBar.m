//
//  WBTabBar.m
//  WeiBo
//
//  Created by wbs on 17/2/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBTabBar.h"

@interface WBTabBar ()

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) NSMutableArray *tabBarButtons;

@end

@implementation WBTabBar

@dynamic delegate;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tabBarButtons removeAllObjects];
    for (UIView *tabBarButton in self.subviews) {
        if ([NSStringFromClass([tabBarButton class]) isEqualToString:@"UITabBarButton"]) {
            [self.tabBarButtons addObject:tabBarButton];
        }
    }

    [self.tabBarButtons insertObject:self.plusButton atIndex:self.tabBarButtons.count / 2];
    
    NSInteger count = self.tabBarButtons.count;
    CGFloat buttonW = self.bounds.size.width / count;
    CGFloat buttonH = self.bounds.size.height;
    CGFloat buttonX = 0.0;
    CGFloat buttonY = 0.0;
    for (int i = 0; i < count; i++) {
        buttonX = i * buttonW;
        UIButton *button = self.tabBarButtons[i];
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
}

- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (UIButton *)plusButton
{
    if (_plusButton == nil) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
        [_plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
        [_plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
        [_plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
        [_plusButton addTarget:self action:@selector(sendWeiBo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_plusButton];
    }
    return _plusButton;
}

- (void)sendWeiBo:(UIButton *)plusButton
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickPlusButton:)]) {
        [self.delegate tabBar:self didClickPlusButton:plusButton];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
