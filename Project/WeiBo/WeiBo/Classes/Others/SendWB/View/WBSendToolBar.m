//
//  WBSendToolBar.m
//  WeiBo
//
//  Created by wbs on 17/3/1.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBSendToolBar.h"

@interface WBSendToolBar ()

@property (nonatomic, weak) UIButton *pictureBtn;
@property (nonatomic, weak) UIButton *mentionBtn;
@property (nonatomic, weak) UIButton *topicBtn;
@property (nonatomic, weak) UIButton *emotionBtn;
@property (nonatomic, weak) UIButton *moreBtn;
@property (nonatomic, weak) UIButton *currentSelectedBtn;

@end

@implementation WBSendToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background_new"]];
        self.pictureBtn = [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:WBSendToolBarButtonTypePicture];
        self.mentionBtn = [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:WBSendToolBarButtonTypeMention];
        self.topicBtn = [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:WBSendToolBarButtonTypeTopic];
        self.emotionBtn = [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:WBSendToolBarButtonTypeEmotion];
        self.moreBtn = [self addButtonWithIcon:@"compose_toolbar_more" highIcon:@"compose_toolbar_more_highlighted" tag:WBSendToolBarButtonTypeMore];
    }
    return self;
}

- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(WBSendToolBarButtonType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
    return button;
}

- (void)buttonClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(sendToolBar:didClickButtonType:)]) {
        [self.delegate sendToolBar:self didClickButtonType:btn.tag];
    }

}

- (void)setShowEmotionButton:(BOOL)showEmotionButton
{
    _showEmotionButton = showEmotionButton;
    if (showEmotionButton) {
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.emotionBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}

- (void)setShowMoreButton:(BOOL)showMoreButton
{
    _showMoreButton = showMoreButton;
    if (showMoreButton) {
        [self.moreBtn setImage:[UIImage imageNamed:@"compose_toolbar_more"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"compose_toolbar_more_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.moreBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.moreBtn setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.subviews.count;
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    for (int i = 0; i < count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}


@end
