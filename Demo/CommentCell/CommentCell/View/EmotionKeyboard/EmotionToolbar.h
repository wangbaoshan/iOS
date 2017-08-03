//
//  EmotionToolbar.h
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EmotionToolbar;

typedef enum : NSUInteger {
    EmotionTypeRecent,
    EmotionTypeDefault,
    EmotionTypeEmoji,
    EmotionTypeLxh
} EmotionType;

@protocol EmotionToolbarDelegate <NSObject>

@optional
- (void)emotionToolbar:(EmotionToolbar *)toolbar didSelectedButton:(EmotionType)emotionType;

@end

@interface EmotionToolbar : UIView

+ (__kindof EmotionToolbar *)toolbar;
@property (nonatomic, weak) id<EmotionToolbarDelegate> delegate;


@end
