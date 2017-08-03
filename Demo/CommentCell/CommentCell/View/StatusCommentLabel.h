//
//  StatusCommentLabel.h
//  CommentCell
//
//  Created by power on 2017/5/23.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusComment;
@class StatusCommentLabel;

@protocol StatusCommentLabelDelegate <NSObject>

@optional
- (void)statusCommentLabel:(StatusCommentLabel *)commentLabel deleteStatusComment:(StatusComment *)comment;

@end


@interface StatusCommentLabel : UILabel

@property (nonatomic, strong) StatusComment *comment;
@property (nonatomic, weak) id<StatusCommentLabelDelegate> delegate;

@end
