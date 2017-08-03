//
//  EmotionContainerView.m
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "EmotionContainerView.h"

#import "Emotion.h"
#import "EmotionView.h"
#import "EmotionConst.h"

@interface EmotionContainerView ()

@property (nonatomic, strong) NSMutableArray<EmotionView *> *emotionViews;

@property (nonatomic, weak) UIButton *deleteButton;

@end

@implementation EmotionContainerView

- (NSMutableArray<EmotionView *> *)emotionViews
{
    if (_emotionViews == nil) {
        _emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
    }
    return self;
}

- (void)deleteClick
{
    
}


- (void)setSubEmotions:(NSArray<Emotion *> *)subEmotions
{
    _subEmotions = subEmotions;
    
    if (self.emotionViews.count < subEmotions.count) { // 不够
        for (int i = 0; i < subEmotions.count; i++) {
            EmotionView *emotionView = nil;
            if (i < self.emotionViews.count) {
                emotionView = self.emotionViews[i];
                emotionView.emotion = subEmotions[i];
            } else {
                emotionView = [[EmotionView alloc] init];
                emotionView.emotion = subEmotions[i];
                [emotionView addTarget:self action:@selector(chooseEmotion:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:emotionView];
                [self.emotionViews addObject:emotionView];
            }
            emotionView.hidden = NO;
        }
    } else {
        for (int i = 0; i < self.emotionViews.count; i++) {
            EmotionView *emotionView = self.emotionViews[i];
            if (i < self.subEmotions.count) {
                emotionView.emotion = subEmotions[i];
                emotionView.hidden = NO;
            } else {
                emotionView.hidden = YES;
            }
        }
    }
}

- (void)chooseEmotion:(EmotionView *)emotionView
{
    NSLog(@"%@", emotionView.emotion);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftM = 15;
    CGFloat topM = 15;
    
    CGFloat emotionViewW = (self.bounds.size.width - 2 * leftM) / EmotionMaxCols;
    CGFloat emotionViewH = (self.bounds.size.height - topM) / EmotionMaxRows;
    
    for (int i = 0; i < self.subEmotions.count; i++) {
        EmotionView *emotionView = self.emotionViews[i];
        CGFloat emotionViewX = leftM + emotionViewW * (i % EmotionMaxCols);
        CGFloat emotionViewY = topM + emotionViewH * (i / EmotionMaxCols);
        emotionView.frame = CGRectMake(emotionViewX, emotionViewY, emotionViewW, emotionViewH);
    }
    
    self.deleteButton.frame = CGRectMake(self.bounds.size.width - leftM - emotionViewW, self.bounds.size.height - emotionViewH, emotionViewW, emotionViewH);
}

@end
