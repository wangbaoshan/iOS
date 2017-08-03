//
//  Emotion.h
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emotion : NSObject

// 表情的文字描述（简体中文）
@property (nonatomic, copy) NSString *chs;
// 表情的文字描述（繁体）
@property (nonatomic, copy) NSString *cht;
// 表情的gif图片名称
@property (nonatomic, copy) NSString *gif;
// 表情的图片名称
@property (nonatomic, copy) NSString *png;
// 表情的类型，0代表图片表情，1代表emoji表情
@property (nonatomic, copy) NSString *type;
// emoji表情的code码，图片表情没有code码
@property (nonatomic, copy) NSString *code;
// emoji表情的文字描述，由code码转化而来
@property (nonatomic, copy) NSString *emojiString;

// 表情的图片路径，获取表情图片的全路径为：directory拼接png
@property (nonatomic, copy) NSString *directory;

@end
