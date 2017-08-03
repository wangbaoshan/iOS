//
//  BSEmotionModel.m
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSEmotionModel.h"

#import "NSString+Emoji.h"

@implementation BSEmotionModel

@end

@implementation BSEmotionGroup

@end

@implementation PTToolbarItem

@end

@implementation BSEmotionItem

@end

@implementation BSEmotion

+ (BSEmotion *)emotionWithDic:(NSDictionary *)dicData
{
    return [[self alloc] initWithDic:dicData];
}

- (BSEmotion *)initWithDic:(NSDictionary *)dicData
{
    if (self = [super init]) {
        
    }
    return self;
}

@end

@implementation BSEmotionSmallPicture

+ (BSEmotion *)emotionWithDic:(NSDictionary *)dicData
{
    return [[self alloc] initWithDic:dicData];
}

- (BSEmotion *)initWithDic:(NSDictionary *)dicData
{
    if (self = [super init]) {
        self.chs = dicData[@"chs"];
        self.png = dicData[@"png"];
    }
    return self;
}

@end

@implementation BSEmotionEmoji

+ (BSEmotion *)emotionWithDic:(NSDictionary *)dicData
{
    return [[self alloc] initWithDic:dicData];
}

- (BSEmotion *)initWithDic:(NSDictionary *)dicData
{
    if (self = [super init]) {
        self.code = dicData[@"code"];
    }
    return self;
}

- (void)setCode:(NSString *)code
{
    _code = [code copy];
    
    self.emojiString = [NSString emojiWithStringCode:code];
}

@end

@implementation BSEmotionLargePicture

+ (BSEmotion *)emotionWithDic:(NSDictionary *)dicData
{
    return [[self alloc] initWithDic:dicData];
}

- (BSEmotion *)initWithDic:(NSDictionary *)dicData
{
    if (self = [super init]) {
        self.urlString = dicData[@"urlString"];
    }
    return self;
}

@end
