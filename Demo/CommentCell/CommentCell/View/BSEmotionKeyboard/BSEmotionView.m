//
//  BSEmotionView.m
//  CommentCell
//
//  Created by power on 2017/6/4.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSEmotionView.h"

#import "BSEmotionModel.h"

@implementation BSEmotionView

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

@end

@implementation PTSmallEmotionView

- (void)setHighlighted:(BOOL)highlighted {}

- (void)setSmallPic:(BSEmotionSmallPicture *)smallPic
{
    _smallPic = smallPic;
    
    [self setImage:smallPic.smallImage forState:UIControlStateNormal];
}

@end

@implementation BSEmojiEmotionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:31];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

- (void)setEmoji:(BSEmotionEmoji *)emoji
{
    _emoji = emoji;
    
    [self setTitle:emoji.emojiString forState:UIControlStateNormal];
}

@end

@implementation PTLargeEmotionView

- (void)setLargePic:(BSEmotionLargePicture *)largePic
{
    _largePic = largePic;
    
    
}

@end
