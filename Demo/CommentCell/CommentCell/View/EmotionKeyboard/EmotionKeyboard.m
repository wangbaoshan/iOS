//
//  EmotionKeyboard.m
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "EmotionKeyboard.h"

#import "EmotionListView.h"
#import "EmotionToolbar.h"
#import "Emotion.h"
#import "MJExtension.h"

@interface EmotionKeyboard () <EmotionToolbarDelegate>

@property (nonatomic, weak) EmotionListView *listView;
@property (nonatomic, weak) EmotionToolbar *toolbar;

@property (nonatomic, strong) NSArray<Emotion *> *defaultEmotions;
@property (nonatomic, strong) NSArray<Emotion *> *emojiEmotions;
@property (nonatomic, strong) NSArray<Emotion *> *lxhEmotions;

@end

@implementation EmotionKeyboard

+ (EmotionKeyboard *)emotionKeyboard
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        EmotionListView *listView = [EmotionListView listView];
        [self addSubview:listView];
        self.listView = listView;
        
        EmotionToolbar *toolbar = [EmotionToolbar toolbar];
        toolbar.delegate = self;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat toolbarH = 35.0f;
    self.listView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - toolbarH);
    self.toolbar.frame = CGRectMake(0, CGRectGetMaxY(self.listView.frame), self.bounds.size.width, toolbarH);
}

- (NSArray<Emotion *> *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [Emotion mj_objectArrayWithFile:plist];
        [_defaultEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
    }
    return _defaultEmotions;
}

- (NSArray<Emotion *> *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [Emotion mj_objectArrayWithFile:plist];
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji"];
    }
    return _emojiEmotions;
}

- (NSArray<Emotion *> *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [Emotion mj_objectArrayWithFile:plist];
        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
    }
    return _lxhEmotions;
}


#pragma mark - EmotionToolbarDelegate

- (void)emotionToolbar:(EmotionToolbar *)toolbar didSelectedButton:(EmotionType)emotionType
{
    switch (emotionType) {
        case EmotionTypeRecent:
            
            break;
            
        case EmotionTypeDefault:
            self.listView.emotions = [self defaultEmotions];
            break;
            
        case EmotionTypeEmoji:
            self.listView.emotions = [self emojiEmotions];
            break;
            
        case EmotionTypeLxh:
            self.listView.emotions = [self lxhEmotions];
            break;
            
        default:
            break;
    }
}


@end
