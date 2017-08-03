//
//  BSEmotionKeyboardCell.m
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSEmotionKeyboardCell.h"

#import "BSEmotionKeyboard.h"
#import "BSEmotionView.h"
#import "BSEmotionConst.h"
#import "BSEmotionModel.h"

@implementation BSEmotionKeyboardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end


@interface PTSmallEmotionKeyboardCell ()
@property (nonatomic, strong) NSMutableArray<PTSmallEmotionView *> *smallViews;
@end
@implementation PTSmallEmotionKeyboardCell

- (NSMutableArray<PTSmallEmotionView *> *)smallViews
{
    if (_smallViews == nil) {
        _smallViews = [NSMutableArray array];
    }
    return _smallViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat leftM = 15.0f;
        CGFloat topM = 10.0f;
        
        CGFloat emotionViewW = (frame.size.width - 2 * leftM) / kEmotionMaxCols;
        CGFloat emotionViewH = (frame.size.height - topM) / kEmotionMaxRows;
        
        for (int i = 0; i < kEmotionMaxCountPerPage; i++) {
            PTSmallEmotionView *smallView = [[PTSmallEmotionView alloc] init];
            CGFloat emotionViewX = leftM + emotionViewW * (i % kEmotionMaxCols);
            CGFloat emotionViewY = topM + emotionViewH * (i / kEmotionMaxCols);
            smallView.frame = CGRectMake(emotionViewX, emotionViewY, emotionViewW, emotionViewH);
            [smallView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:smallView];
            [self.smallViews addObject:smallView];
        }
        
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.frame = CGRectMake(frame.size.width - leftM - emotionViewW, frame.size.height - emotionViewH, emotionViewW, emotionViewH);
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
    }
    return self;
}

- (void)setItem:(BSEmotionItem *)item
{
    _item = item;
    
    for (NSInteger i = 0; i < self.smallViews.count; i++) {
        PTSmallEmotionView *smallView = self.smallViews[i];
        if (i < item.emotions.count) {
            smallView.hidden = NO;
            BSEmotionSmallPicture *smallPic = item.emotions[i];
            smallView.smallPic = smallPic;
        } else {
            smallView.hidden = YES;
        }
    }
}

- (void)emotionClick:(PTSmallEmotionView *)smallView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickSmallPicture object:smallView.smallPic];
}

- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickDeleteButton object:nil];
}

@end


@interface BSEmojiEmotionKeyboardCell ()
@property (nonatomic, strong) NSMutableArray<BSEmojiEmotionView *> *emojiViews;
@end
@implementation BSEmojiEmotionKeyboardCell

- (NSMutableArray<BSEmojiEmotionView *> *)emojiViews
{
    if (_emojiViews == nil) {
        _emojiViews = [NSMutableArray array];
    }
    return _emojiViews;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat leftM = 15.0f;
        CGFloat topM = 10.0f;
        
        CGFloat emotionViewW = (frame.size.width - 2 * leftM) / kEmotionMaxCols;
        CGFloat emotionViewH = (frame.size.height - topM) / kEmotionMaxRows;
        
        for (int i = 0; i < kEmotionMaxCountPerPage; i++) {
            BSEmojiEmotionView *emojiView = [[BSEmojiEmotionView alloc] init];
            CGFloat emotionViewX = leftM + emotionViewW * (i % kEmotionMaxCols);
            CGFloat emotionViewY = topM + emotionViewH * (i / kEmotionMaxCols);
            emojiView.frame = CGRectMake(emotionViewX, emotionViewY, emotionViewW, emotionViewH);
            [emojiView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:emojiView];
            [self.emojiViews addObject:emojiView];
        }
        
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        deleteButton.frame = CGRectMake(frame.size.width - leftM - emotionViewW, frame.size.height - emotionViewH, emotionViewW, emotionViewH);
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteButton];
    }
    return self;
}

- (void)setItem:(BSEmotionItem *)item
{
    _item = item;
    
    for (NSInteger i = 0; i < self.emojiViews.count; i++) {
        BSEmojiEmotionView *emojiView = self.emojiViews[i];
        if (i < item.emotions.count) {
            emojiView.hidden = NO;
            BSEmotionEmoji *emoji = item.emotions[i];
            emojiView.emoji = emoji;
        } else {
            emojiView.hidden = YES;
        }
    }
}

- (void)emotionClick:(BSEmojiEmotionView *)emojiView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickEmoji object:emojiView.emoji];
}

- (void)deleteClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEmotionKeyboardDidClickDeleteButton object:nil];
}

@end


@implementation PTLargeEmotionKeyboardCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setItem:(BSEmotionItem *)item
{
    _item = item;
}

@end
