//
//  Emotion.m
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "Emotion.h"

#import "NSString+Emoji.h"

@implementation Emotion

- (NSString *)description
{
    return [NSString stringWithFormat:@"描述：%@； 图片名称： %@； emoji码：%@； emoji描述：%@", self.chs, self.png, self.code, self.emojiString];
}

- (void)setCode:(NSString *)code
{
    _code = [code copy];
    
    self.emojiString = [NSString emojiWithStringCode:code];
}

@end
