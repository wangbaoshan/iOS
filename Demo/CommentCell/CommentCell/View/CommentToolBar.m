//
//  CommentToolBar.m
//  CommentCell
//
//  Created by power on 2017/5/24.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "CommentToolBar.h"

@interface CommentToolBar ()
@property (weak, nonatomic) IBOutlet UIButton *keyboardChangeButton;

@end

@implementation CommentToolBar

+ (instancetype)toolBar
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background_new"]];
    self.textFileld.enablesReturnKeyAutomatically = YES;
}

- (void)setShowEmotionButton:(BOOL)showEmotionButton
{
    _showEmotionButton = showEmotionButton;
    if (showEmotionButton) {
        [self.keyboardChangeButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background"] forState:UIControlStateNormal];
        [self.keyboardChangeButton setImage:[UIImage imageNamed:@"compose_emoticonbutton_background_highlighted"] forState:UIControlStateHighlighted];
    } else {
        [self.keyboardChangeButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.keyboardChangeButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
    }
}

- (IBAction)keyboardChange {
    if ([self.delegate respondsToSelector:@selector(commentToolBar:didClickKeyboardChangeButton:)]) {
        [self.delegate commentToolBar:self didClickKeyboardChangeButton:self.keyboardChangeButton];
    }
}

@end
