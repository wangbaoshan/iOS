//
//  StatusCommentsView.h
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusComment;
@class StatusCommentsView;

@protocol StatusCommentsViewDelegate <NSObject>

@optional
- (void)statusCommentsView:(StatusCommentsView *)commentsView statusComments:(NSArray<StatusComment *> *)comments deleteStatusComment:(StatusComment *)comment;

@end

@interface StatusCommentsView : UIView

+ (CGSize)sizeWith:(NSArray<StatusComment *> *)comments maxWidth:(CGFloat)maxWidth padding:(CGFloat)padding margin:(CGFloat)margin;

@property (nonatomic, strong) NSArray<StatusComment *> *comments;
@property (nonatomic, weak) id<StatusCommentsViewDelegate> delegate;

@end
