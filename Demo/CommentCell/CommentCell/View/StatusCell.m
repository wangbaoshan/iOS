//
//  StatusCell.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusCell.h"

#import "StatusPhotosView.h"
#import "StatusCommentsView.h"
#import "StatusFrameModel.h"
#import "StatusModel.h"
#import "UIImageView+WebCache.h"

@interface StatusCell () <StatusCommentsViewDelegate>

//@property (nonatomic, weak) UIView *totalView;
//@property (nonatomic, weak) UIImageView *iconView;
//@property (nonatomic, weak) UILabel *nameLabel;
//@property (nonatomic, weak) UILabel *contentLabel;
//@property (nonatomic, weak) StatusPhotosView *photosView;
//@property (nonatomic, weak) UIButton *commentButton;
//@property (nonatomic, weak) StatusCommentsView *commentsView;

@end

@implementation StatusCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"status";
    StatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    // total
    UIView *totalView = [[UIView alloc] init];
    [self.contentView addSubview:totalView];
    self.totalView = totalView;
    
    // 头像
    UIImageView *iconView = [[UIImageView alloc] init];
    [totalView addSubview:iconView];
    self.iconView = iconView;
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kStatusNameFont;
    [totalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = kStatusContentFont;
    [totalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 图片
    StatusPhotosView *photosView = [[StatusPhotosView alloc] init];
    [totalView addSubview:photosView];
    self.photosView = photosView;
    
    // 评论按钮
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.backgroundColor = [UIColor lightGrayColor];
    commentButton.titleLabel.font = kStatusCommentButtonFont;
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitle:@"评论" forState:UIControlStateHighlighted];
    [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    [commentButton addTarget:self action:@selector(willComment) forControlEvents:UIControlEventTouchUpInside];
    [totalView addSubview:commentButton];
    self.commentButton = commentButton;
    
    // 评论
    StatusCommentsView *commentsView = [[StatusCommentsView alloc] init];
    commentsView.delegate = self;
    [totalView addSubview:commentsView];
    self.commentsView = commentsView;
}

- (void)willComment
{
    if ([self.delegate respondsToSelector:@selector(statusCell:didClickCommentButton:tableViewIndexPath:)]) {
        [self.delegate statusCell:self didClickCommentButton:self.commentButton tableViewIndexPath:self.currentIndexPath];
    }
}

- (void)setFrameModel:(StatusFrameModel *)frameModel
{
    _frameModel = frameModel;
    
    self.totalView.frame = frameModel.totalViewF;
    self.iconView.frame = frameModel.iconViewF;
    self.nameLabel.frame = frameModel.nameLabelF;
    self.contentLabel.frame = frameModel.contentLabelF;
    self.photosView.frame = frameModel.photosViewF;
    self.commentButton.frame = frameModel.commentButtonF;
    self.commentsView.frame = frameModel.commentsViewF;
    
    StatusModel *model = frameModel.model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.nameLabel.text = model.name;
    self.contentLabel.text = model.content;
    self.photosView.photos = model.photos;
    self.commentsView.comments = model.comments;
}

#pragma mark - StatusCommentsViewDelegate

- (void)statusCommentsView:(StatusCommentsView *)commentsView statusComments:(NSArray<StatusComment *> *)comments deleteStatusComment:(StatusComment *)comment
{
    if ([self.delegate respondsToSelector:@selector(statusCell:comments:deleteComment:tableViewIndexPath:)]) {
        [self.delegate statusCell:self comments:comments deleteComment:comment tableViewIndexPath:self.currentIndexPath];
    }
}

@end
