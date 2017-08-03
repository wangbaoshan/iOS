//
//  AVSpeechCotroller.m
//  Sharp Time
//
//  Created by power on 2017/7/24.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "AVSpeechCotroller.h"

@interface AVSpeechCotroller ()

@property (nonatomic, strong) NSArray<AVSpeechSynthesisVoice *> *voices;
@property (nonatomic, strong) NSArray<NSString *> *speechStrings;

@end

@implementation AVSpeechCotroller

- (void)dealloc
{
    STLogMothodFunc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化AVSpeechSynthesizer
        _synthesizer = [[MyAVSpeechSynthesizer alloc] init];
        
        // 数组里边装了两种语音，用于播放
        _voices = @[[AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"], [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]];
        
        // 播放数据
        _speechStrings = [self buildSpeechStrings];
        
    }
    return self;
}

- (NSArray<NSString *> *)buildSpeechStrings
{
    return @[@"Hello AV Foundation. How are you?",
             @"I'm well! Thanks for asking.",
             @"Are you excited about the book?",
             @"Very! I have always felt so misunderstood.",
             @"What's your favorite feature?",
             @"Oh, they're all my babies.  I couldn't possibly choose.",
             @"It was great to speak with you!",
             @"The pleasure was all mine!  Have fun!"];
}

/// 开始播放操作
- (void)beginConversation
{
    for (int i = 0; i < self.speechStrings.count; i++) {
        // 创建语音播放AVSpeechUtterance对象
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:self.speechStrings[i]];
        // 设置语音类型
        utterance.voice = self.voices[i % 2];
        // 设置播放速率
        utterance.rate = 0.5f;
        // 设置音调
        utterance.pitchMultiplier = 0.8f;
        // 设置读一语音之前的停顿时间
        utterance.preUtteranceDelay = 0.1f;
        // 设置读一语音之后的停顿时间
        utterance.postUtteranceDelay = 0.1f;
        // 开始播放语音
        [self.synthesizer speakUtterance:utterance];
    }
}

@end

@implementation MyAVSpeechSynthesizer

- (void)dealloc
{
    STLogMothodFunc;
}

@end
