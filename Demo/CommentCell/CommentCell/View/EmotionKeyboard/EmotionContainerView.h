//
//  EmotionContainerView.h
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Emotion;

@interface EmotionContainerView : UIView

@property (nonatomic, strong) NSArray<Emotion *> *subEmotions;


@end
