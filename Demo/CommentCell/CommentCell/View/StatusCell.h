//
//  StatusCell.h
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusFrameModel;
@class StatusCell;
@class StatusComment;
@class StatusCommentsView;
@class StatusPhotosView;

@protocol StatusCellDelegate <NSObject>

@optional
- (void)statusCell:(StatusCell *)statusCell didClickCommentButton:(UIButton *)commentButton tableViewIndexPath:(NSIndexPath *)indexPath;
- (void)statusCell:(StatusCell *)statusCell comments:(NSArray<StatusComment *> *)comments deleteComment:(StatusComment *)comment tableViewIndexPath:(NSIndexPath *)indexPath;

@end

@interface StatusCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIView *totalView;
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) StatusPhotosView *photosView;
@property (nonatomic, weak) UIButton *commentButton;
@property (nonatomic, weak) StatusCommentsView *commentsView;

@property (nonatomic, strong) StatusFrameModel *frameModel;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, weak) id<StatusCellDelegate> delegate;

@end
