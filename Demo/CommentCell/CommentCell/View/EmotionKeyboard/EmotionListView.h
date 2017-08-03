//
//  EmotionListView.h
//  CommentCell
//
//  Created by power on 2017/5/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Emotion;

@interface EmotionListView : UIView

+ (__kindof EmotionListView *)listView;

@property (nonatomic, strong) NSArray<Emotion *> *emotions;

@end
