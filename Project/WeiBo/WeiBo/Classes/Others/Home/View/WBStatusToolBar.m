//
//  WBStatusToolBar.m
//  WeiBo
//
//  Created by wbs on 17/2/27.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusToolBar.h"
#import "WBStatusToolBarButton.h"
#import "WBStatus.h"

@interface WBStatusToolBar ()

@property (nonatomic, strong) NSMutableArray<WBStatusToolBarButton *> *btns;
@property (nonatomic, weak) UIButton *repostsBtn;
@property (nonatomic, weak) UIButton *commentsBtn;
@property (nonatomic, weak) UIButton *attitudesBtn;

@end

@implementation WBStatusToolBar

- (NSMutableArray<WBStatusToolBarButton *> *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

+ (WBStatusToolBar *)statusToolBar
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.repostsBtn = [self setupBtnWithIcon:@"timeline_icon_retweet" title:@"转发"];
        self.commentsBtn = [self setupBtnWithIcon:@"timeline_icon_comment" title:@"评论"];
        self.attitudesBtn =[self setupBtnWithIcon:@"timeline_icon_unlike" title:@"赞"];
    }
    return self;
}

- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    WBStatusToolBarButton *btn = [[WBStatusToolBarButton alloc] init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置高亮时的背景
    [btn setBackgroundImage:[UIImage resizedImageWithImageStr:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.btns.count;
    CGFloat btnW = self.bounds.size.width / count;
    CGFloat btnH = self.bounds.size.height - 0.4;
    CGFloat x = 0;
    CGFloat y = 0.4;
    for (int i = 0; i < count; i++) {
        WBStatusToolBarButton *btn = self.btns[i];
        x = i * btnW;
        btn.frame = CGRectMake(x, y, btnW, btnH);
    }
}

- (void)drawRect:(CGRect)rect
{
//    [[UIImage resizedImageWithImageStr:@"common_card_bottom_background"] drawInRect:rect];
}

- (void)click:(WBStatusToolBarButton *)btn
{
    if (btn == self.repostsBtn) {
        kWBLog(@"转发");
    } else if (btn == self.commentsBtn) {
        kWBLog(@"评论");
    } else {
        kWBLog(@"赞");
    }
}

- (void)setStatus:(WBStatus *)status
{
    _status = status;
    
    [self setupBtnTitle:self.repostsBtn count:status.reposts_count.integerValue defaultTitle:@"转发"];
    [self setupBtnTitle:self.commentsBtn count:status.comments_count.integerValue defaultTitle:@"评论"];
    [self setupBtnTitle:self.attitudesBtn count:status.attitudes_count.integerValue defaultTitle:@"赞"];

}

- (void)setupBtnTitle:(UIButton *)button count:(NSInteger)count defaultTitle:(NSString *)defaultTitle
{
    if (count >= 10000) { // [10000, 无限大)
        defaultTitle = [NSString stringWithFormat:@"%.1f万", count / 10000.0];
        // 用空串替换掉所有的.0
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    } else if (count > 0) { // (0, 10000)
        defaultTitle = [NSString stringWithFormat:@"%ld", (long)count];
    }
    [button setTitle:defaultTitle forState:UIControlStateNormal];
}


@end
