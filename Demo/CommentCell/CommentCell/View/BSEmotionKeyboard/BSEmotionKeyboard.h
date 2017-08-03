//
//  BSEmotionKeyboard.h
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickSmallPicture;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickEmoji;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickLargePicture;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickDeleteButton;

@class BSEmotionModel;

@interface BSEmotionKeyboard : UIView

+ (__kindof BSEmotionKeyboard *)emotionKeyboard;

@property (class, nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) NSArray<BSEmotionModel *> *emotionModels;

@end
