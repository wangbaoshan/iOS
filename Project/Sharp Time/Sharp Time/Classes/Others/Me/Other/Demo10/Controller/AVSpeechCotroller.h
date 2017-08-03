//
//  AVSpeechCotroller.h
//  Sharp Time
//
//  Created by power on 2017/7/24.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@class MyAVSpeechSynthesizer;

@interface AVSpeechCotroller : NSObject

@property (nonatomic, strong, readonly) MyAVSpeechSynthesizer *synthesizer;
- (void)beginConversation;

@end


@interface MyAVSpeechSynthesizer : AVSpeechSynthesizer

@end
