//
//  BSEmotionKeyboard.h
//  CommentCell
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 外部需添加通知监听
 kEmotionKeyboardDidClickSmallPicture  当点击了小表情时发出通知
 kEmotionKeyboardDidClickEmoji         当点击了emoji表情时发出通知
 kEmotionKeyboardDidClickLargePicture  当点击了大表情时发出通知
 kEmotionKeyboardDidClickDeleteButton  当点击了表情键盘上的删除键时发出通知
 kEmotionKeyboardDidClickSendButton    当点击了表情键盘上的发送键时发出通知
 kEmotionKeyboardDidClickAddButton     当点击了添加键时发出通知
 */
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickSmallPicture;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickEmoji;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickLargePicture;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickDeleteButton;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickSendButton;
UIKIT_EXTERN NSString *const kEmotionKeyboardDidClickAddButton;

@class BSEmotionModel;

@interface BSEmotionKeyboard : UIView

/// 设置键盘高度，默认为216.0f
@property (class, nonatomic, assign) CGFloat keyboardHeight;
/// 初始化
+ (__kindof BSEmotionKeyboard *)emotionKeyboard;
/// 给键盘传递的模型数组
@property (nonatomic, strong) NSArray<BSEmotionModel *> *emotionModels;

@end
