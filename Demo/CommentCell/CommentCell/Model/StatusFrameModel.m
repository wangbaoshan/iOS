//
//  StatusFrameModel.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusFrameModel.h"

#import "StatusModel.h"
#import "StatusPhotosView.h"
#import "StatusCommentsView.h"


@implementation StatusFrameModel

- (void)setModel:(StatusModel *)model
{
    _model = model;
    
    // totalView
    CGFloat totalViewW = kCellWidth;
    CGFloat totalViewX = 0;
    CGFloat totalViewY = 0;
    CGFloat totalViewH = 0;
    
    // iconView
    CGFloat iconViewW = 45.0;
    CGFloat iconViewH = iconViewW;
    CGFloat iconViewX = kMargin;
    CGFloat iconViewY = kMargin;
    _iconViewF = CGRectMake(iconViewX, iconViewY, iconViewW, iconViewH);
    
    // nameLabel
    CGFloat nameLabelX = CGRectGetMaxX(_iconViewF) + kMargin;
    CGFloat nameLabelY = iconViewY;
    CGSize nameLabelSize = [model.name sizeWithAttributes:@{NSFontAttributeName : kStatusNameFont}];
    _nameLabelF = (CGRect){{nameLabelX, nameLabelY}, nameLabelSize};
    
    // contentLabel
    CGFloat contentLabelX = nameLabelX;
    CGFloat contentLabelY = CGRectGetMaxY(_nameLabelF) + kPadding;
    CGFloat contentLabelW = totalViewW - contentLabelX - kMargin * 2;
    CGSize contentLabelSize = [model.content boundingRectWithSize:CGSizeMake(contentLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kStatusContentFont} context:nil].size;
    _contentLabelF = (CGRect){{contentLabelX, contentLabelY}, contentLabelSize};
    
    // photosView
    CGFloat photoViewX = contentLabelX;
    CGFloat photoViewY = 0.0f;
    if (model.photos.count) {
        photoViewY = CGRectGetMaxY(_contentLabelF) + kPadding;
        CGFloat maxW = kCellWidth - photoViewX * 2;
        CGSize photosViewSize = [StatusPhotosView sizeWithMaxWidth:maxW maxCount:model.photos.count margin:3.0];
        _photosViewF = CGRectMake(photoViewX, photoViewY, photosViewSize.width, photosViewSize.height);
    } else {
        photoViewY = CGRectGetMaxY(_contentLabelF);
        _photosViewF = CGRectMake(photoViewX, photoViewY, 0, 0);
    }
    
    // commentButton
    CGFloat commentButtonW = 35.0;
    CGFloat commentButtonH = 20.0;
    CGFloat commentButtonY = CGRectGetMaxY(_photosViewF) + kPadding;
    CGFloat commentButtonX = kCellWidth - commentButtonW - kMargin;
    _commentButtonF = CGRectMake(commentButtonX, commentButtonY, commentButtonW, commentButtonH);
    
    // commentsView
    CGFloat commentsViewX = photoViewX;
    CGFloat commentsViewY = 0.0f;
    if (model.comments.count) {
        commentsViewY = CGRectGetMaxY(_commentButtonF) + kPadding;
        CGFloat maxW = kCellWidth - commentsViewX - kMargin;
        CGSize commentsViewSize = [StatusCommentsView sizeWith:model.comments maxWidth:maxW padding:5.0 margin:5.0];
        _commentsViewF = CGRectMake(commentsViewX, commentsViewY, commentsViewSize.width, commentsViewSize.height);
    } else {
        commentsViewY = CGRectGetMaxY(_commentButtonF);
        _commentsViewF = CGRectMake(commentsViewX, commentsViewY, 0, 0);
    }

    totalViewH = CGRectGetMaxY(_commentsViewF) + kMargin;
    _totalViewF = CGRectMake(totalViewX, totalViewY, totalViewW, totalViewH);
    
    _cellHeight = CGRectGetMaxY(_totalViewF);
}

@end
