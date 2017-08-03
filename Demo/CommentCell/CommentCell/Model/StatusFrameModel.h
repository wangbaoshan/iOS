//
//  StatusFrameModel.h
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class StatusModel;

#define kCellWidth [UIScreen mainScreen].bounds.size.width
#define kMargin 12.0f
#define kPadding 10.0f

#define kStatusNameFont [UIFont systemFontOfSize:15.0f]
#define kStatusContentFont [UIFont systemFontOfSize:15.0f]
#define kStatusCommentButtonFont [UIFont systemFontOfSize:13.0f]
#define kStatusCommentFont [UIFont systemFontOfSize:14.0f]

@interface StatusFrameModel : NSObject

@property (nonatomic, strong) StatusModel *model;

@property (nonatomic, assign, readonly) CGRect totalViewF;
@property (nonatomic, assign, readonly) CGRect iconViewF;
@property (nonatomic, assign, readonly) CGRect nameLabelF;
@property (nonatomic, assign, readonly) CGRect contentLabelF;
@property (nonatomic, assign, readonly) CGRect photosViewF;
@property (nonatomic, assign, readonly) CGRect commentButtonF;
@property (nonatomic, assign, readonly) CGRect commentsViewF;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end

/**
 @property (nonatomic, weak) UIView *totalView;
 @property (nonatomic, weak) UIImageView *iconView;
 @property (nonatomic, weak) UILabel *nameLabel;
 @property (nonatomic, weak) UILabel *contentLabel;
 @property (nonatomic, weak) StatusPhotosView *photosView;
 @property (nonatomic, weak) UIButton *commentButton;
 @property (nonatomic, weak) StatusCommentsView *commentsView;
 */
