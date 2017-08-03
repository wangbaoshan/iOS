//
//  EmotionToolbar.m
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "EmotionToolbar.h"

#import "UIImage+BS.h"

@interface EmotionToolbar ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttons;
@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation EmotionToolbar

- (NSMutableArray<UIButton *> *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

+ (EmotionToolbar *)toolbar
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self.buttons addObject:[self addButton:@"最近" type:EmotionTypeRecent]];
        [self.buttons addObject:[self addButton:@"默认" type:EmotionTypeDefault]];
        [self.buttons addObject:[self addButton:@"Emoji" type:EmotionTypeEmoji]];
        [self.buttons addObject:[self addButton:@"浪小花" type:EmotionTypeLxh]];

    }
    return self;
}

- (UIButton *)addButton:(NSString *)title type:(EmotionType)type
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = type;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage resizedImageWithImageStr:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage resizedImageWithImageStr:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13.5];
    
    [self addSubview:button];
    
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    if (self.selectedButton == button) return;
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
        [self.delegate emotionToolbar:self didSelectedButton:button.tag];
    }
}

- (void)setDelegate:(id<EmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    UIButton *defaultButton = self.buttons[0];
    [self buttonClick:defaultButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置工具条按钮的frame
    CGFloat buttonX = 0.0f;
    CGFloat buttonY = 0.0f;
    CGFloat buttonW = 50.0f;
    CGFloat buttonH = self.bounds.size.height;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}


@end
