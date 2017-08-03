//
//  CommentToolBar.h
//  CommentCell
//
//  Created by power on 2017/5/24.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommentToolBar;

@protocol CommentToolBarDelegate <NSObject>

@optional
- (void)commentToolBar:(CommentToolBar *)commentToolBar didClickKeyboardChangeButton:(UIButton *)keyboardChangeButton;

@end

@interface CommentToolBar : UIView

+ (instancetype)toolBar;

@property (weak, nonatomic) IBOutlet UITextField *textFileld;
@property (nonatomic, weak) id<CommentToolBarDelegate> delegate;

@property (nonatomic, assign, getter = isShowEmotionButton) BOOL showEmotionButton;

@end
