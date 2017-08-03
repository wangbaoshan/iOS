//
//  BSEmotionView.h
//  CommentCell
//
//  Created by power on 2017/6/4.
//  Copyright © 2017年 powertorque. All rights reserved.
//  

#import <UIKit/UIKit.h>

@class BSEmotionSmallPicture;
@class BSEmotionEmoji;
@class BSEmotionLargePicture;

@interface BSEmotionView : UIButton

@end


@interface PTSmallEmotionView : BSEmotionView
@property (nonatomic, strong) BSEmotionSmallPicture *smallPic;
@end


@interface BSEmojiEmotionView : BSEmotionView
@property (nonatomic, strong) BSEmotionEmoji *emoji;
@end


@interface PTLargeEmotionView : UIView
@property (nonatomic, strong) BSEmotionLargePicture *largePic;
@end


