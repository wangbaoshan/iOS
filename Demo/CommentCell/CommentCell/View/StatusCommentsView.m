//
//  StatusCommentsView.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusCommentsView.h"

#import "StatusModel.h"
#import "StatusFrameModel.h"
#import "StatusCommentLabel.h"

static CGFloat kSelfMaxWidth = 0.0f;
static CGFloat kSelfPadding = 0.0f;
static CGFloat kSelfMargin = 0.0f;

@interface StatusCommentsView () <StatusCommentLabelDelegate>

@end

@implementation StatusCommentsView

+ (CGSize)sizeWith:(NSArray<StatusComment *> *)comments maxWidth:(CGFloat)maxWidth padding:(CGFloat)padding margin:(CGFloat)margin
{
    if (!comments.count) return CGSizeZero;
    kSelfMaxWidth = maxWidth;
    kSelfPadding = padding;
    kSelfMargin = margin;
    CGFloat height = padding * (comments.count + 1);
    CGFloat width = maxWidth - margin * 2;
    for (StatusComment *comment in comments) {
        NSString *unionString = comment.unionComment;
        CGSize size = [unionString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kStatusCommentFont} context:nil].size;
        height += size.height;
    }
    return CGSizeMake(maxWidth, height);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setComments:(NSArray<StatusComment *> *)comments
{
    _comments = comments;
    
    if (self.subviews.count < comments.count) {
        for (NSInteger i = 0; i < comments.count; i++) {
            StatusComment *comment = comments[i];
            if (i < self.subviews.count) {
                StatusCommentLabel *commentLabel = self.subviews[i];
                commentLabel.comment = comment;
                commentLabel.hidden = NO;
            } else {
                StatusCommentLabel *commentLabel = [[StatusCommentLabel alloc] init];
                commentLabel.tag = i;
                commentLabel.delegate = self;
                [self addSubview:commentLabel];
                commentLabel.comment = comment;
                commentLabel.hidden = NO;
            }
        }
    } else {
        for (NSInteger i = 0; i < self.subviews.count; i++) {
            StatusCommentLabel *commentLabel = self.subviews[i];
            if (i < comments.count) {
                commentLabel.hidden = NO;
                StatusComment *comment = comments[i];
                commentLabel.comment = comment;
            } else {
                commentLabel.hidden = YES;
                commentLabel.comment = nil;
            }
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.comments.count;
    CGFloat width = kSelfMaxWidth - kSelfMargin * 2;
    CGFloat x = kSelfMargin;
    CGFloat y = 0.0f;
    for (int i = 0; i < count; i++) {
        StatusCommentLabel *commentLabel = self.subviews[i];
        StatusComment *comment = self.comments[i];
        y = (i == 0) ? kSelfPadding : CGRectGetMaxY(self.subviews[i - 1].frame) + kSelfPadding;
        CGFloat height = [comment.unionComment boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kStatusCommentFont} context:nil].size.height;
        commentLabel.frame = CGRectMake(x, y, width, height);
    }
}

#pragma mark - StatusCommentLabelDelegate

- (void)statusCommentLabel:(StatusCommentLabel *)commentLabel deleteStatusComment:(StatusComment *)comment
{
    if ([self.delegate respondsToSelector:@selector(statusCommentsView:statusComments:deleteStatusComment:)]) {
        [self.delegate statusCommentsView:self statusComments:self.comments deleteStatusComment:comment];
    }
}

@end
