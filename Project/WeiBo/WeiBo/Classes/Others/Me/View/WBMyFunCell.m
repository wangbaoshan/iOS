//
//  WBMyFunCell.m
//  WeiBo
//
//  Created by bao on 2017/8/28.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "WBMyFunCell.h"

#import "WBMyFuns.h"
#import "WBStatus.h"

@interface WBMyFunCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;

@end

@implementation WBMyFunCell

- (IBAction)attention {
}

+ (WBMyFunCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"WBMyFunCell";
    WBMyFunCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.font = [UIFont systemFontOfSize:13];
    self.sourceLabel.font = [UIFont systemFontOfSize:13];
    
    self.iconView.layer.cornerRadius = kWBMyFunCellIconViewHeight * 0.5;
    self.iconView.clipsToBounds = YES;
    
    self.attentionButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.attentionButton setBackgroundImage:[UIImage imageWithColor:kBaseViewControllerBackgroundColor alpha:1.0] forState:UIControlStateHighlighted];
}

#pragma mark - Setter

- (void)setMyFun:(WBMyFun *)myFun
{
    _myFun = myFun;
    
    self.nameLabel.text = myFun.name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:myFun.avatar_large] placeholderImage:[UIImage imageNamed:@"sign-up_avatar_default"]];
    self.contentLabel.text = myFun.status.text;
    self.attentioned = myFun.following;
}

- (void)setAttentioned:(BOOL)attentioned
{
    _attentioned = attentioned;
    if (attentioned) {
        [self.attentionButton setTitle:@"互相关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [self.attentionButton setTitle:@"加关注" forState:UIControlStateNormal];
        [self.attentionButton setTitleColor:kSystemNavigationItemHighlightColor forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
