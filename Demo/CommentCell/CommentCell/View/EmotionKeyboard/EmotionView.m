//
//  EmotionView.m
//  CommentCell
//
//  Created by power on 2017/5/27.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "EmotionView.h"

#import "Emotion.h"

@implementation EmotionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    
}

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code) { // 是emoji
        [self setTitle:emotion.emojiString forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
    } else {
        NSString *imageName = [NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png];
        UIImage *image = [UIImage imageNamed:imageName];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitle:nil forState:UIControlStateNormal];
    }
}

@end
