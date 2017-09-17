//
//  BSEmotionModel.h
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BSEmotionType_SmallPicture = 0, // 本地小图
    BSEmotionType_Emoji, // emoji
    BSEmotionType_LargePicture // 网络大图
} BSEmotionType;

@class BSEmotionItem;
@class BSEmotion;
@class PTToolbarItem;

@interface BSEmotionModel : NSObject
@property (nonatomic, assign) BSEmotionType emotionType;
@property (nonatomic, copy) NSString *plistDirectory;
@property (nonatomic, copy) NSString *directory;
@property (nonatomic, strong) PTToolbarItem *toolbarItem;
@end


@interface PTToolbarItem : NSObject
@property (nonatomic, copy) NSString *indexImageString;
@property (nonatomic, copy) NSString *indexTextString;
@end


@interface BSEmotionGroup : NSObject
@property (nonatomic, assign) BSEmotionType emotionType;
@property (nonatomic, strong) NSArray<BSEmotionItem *> *items;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@end


@interface BSEmotionItem : NSObject
@property (nonatomic, strong) NSArray<__kindof BSEmotion *> *emotions;
@end


@interface BSEmotion : NSObject
// 表情类型
@property (nonatomic, assign) BSEmotionType emotionType;

+ (__kindof BSEmotion *)emotionWithDic:(NSDictionary *)dicData;
- (__kindof BSEmotion *)initWithDic:(NSDictionary *)dicData;
@end


@interface BSEmotionSmallPicture : BSEmotion
// 表情图片的描述
@property (nonatomic, copy) NSString *chs;
// 表情图片的本地名称
@property (nonatomic, copy) NSString *png;
// 表情图片的本地路径
@property (nonatomic, copy) NSString *directory;
// 图片
@property (nonatomic, strong) UIImage *smallImage;
@end

@interface BSEmotionEmoji : BSEmotion
// emoji的code
@property (nonatomic, copy) NSString *code;
// emoji表情的文字描述，由code码转化而来
@property (nonatomic, copy) NSString *emojiString;
@end

@interface BSEmotionLargePicture : BSEmotionSmallPicture
// 表情图片的远程路径
@property (nonatomic, copy) NSString *urlString;
@end
