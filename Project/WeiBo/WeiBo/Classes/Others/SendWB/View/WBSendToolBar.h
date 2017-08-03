//
//  WBSendToolBar.h
//  WeiBo
//
//  Created by wbs on 17/3/1.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBSendToolBar;

typedef enum : NSUInteger {
    WBSendToolBarButtonTypePicture,
    WBSendToolBarButtonTypeMention,
    WBSendToolBarButtonTypeTopic,
    WBSendToolBarButtonTypeEmotion,
    WBSendToolBarButtonTypeMore
} WBSendToolBarButtonType;

@protocol WBSendToolBarDelegate <NSObject>

@optional
- (void)sendToolBar:(WBSendToolBar *)toolBar didClickButtonType:(WBSendToolBarButtonType)buttonType;

@end

@interface WBSendToolBar : UIView

@property (nonatomic, weak) id<WBSendToolBarDelegate> delegate;

@property (nonatomic, assign, getter = isShowEmotionButton) BOOL showEmotionButton;
@property (nonatomic, assign, getter = isShowMoreButton) BOOL showMoreButton;

@end
