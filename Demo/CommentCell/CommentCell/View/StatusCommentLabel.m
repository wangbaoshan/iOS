//
//  StatusCommentLabel.m
//  CommentCell
//
//  Created by power on 2017/5/23.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusCommentLabel.h"

#import "StatusModel.h"
#import "StatusFrameModel.h"

@implementation StatusCommentLabel

- (void)setComment:(StatusComment *)comment
{
    _comment = comment;
    
    self.text = comment.unionComment;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        self.font = kStatusCommentFont;
        self.numberOfLines = 0;
        
        self.userInteractionEnabled = YES;  // 用户交互
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:longPressGes];
    }
    return self;
}

- (void)handleTap:(UILongPressGestureRecognizer *)longPressGes
{
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        
        [self becomeFirstResponder];  // 一定要成为第一响应者
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    } else if (action == @selector(delete:)) {
        return YES;
    } else if (action == @selector(cut:)) {
        return NO;
    } else if(action == @selector(paste:)) {
        return NO;
    } else if(action == @selector(select:)) {
        return NO;
    } else if(action == @selector(selectAll:)){
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)copy:(id)sender
{
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.text];
}

- (void)delete:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(statusCommentLabel:deleteStatusComment:)]) {
        [self.delegate statusCommentLabel:self deleteStatusComment:self.comment];
    }
}

- (void)cut:(id)sender {}
- (void)paste:(id)sender {}
- (void)select:(id)sender {}
- (void)selectAll:(id)sender {}


@end
