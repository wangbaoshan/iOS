//
//  WBMeHeaderView.m
//  WeiBo
//
//  Created by wbs on 17/3/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBMeHeaderView.h"

#import "WBUser.h"

@interface WBMeHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet WBMeHeaderViewLabel *statusCountLabel;
@property (weak, nonatomic) IBOutlet WBMeHeaderViewLabel *attentionCountLabel;
@property (weak, nonatomic) IBOutlet WBMeHeaderViewLabel *funsCountLabel;

@property (nonatomic, weak) UITapGestureRecognizer *selfTapGes;

- (IBAction)arrowClick;

@end

@implementation WBMeHeaderView

+ (WBMeHeaderView *)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.clipsToBounds = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
    self.desLabel.font = [UIFont systemFontOfSize:13.5];
    self.desLabel.textColor = kCSSHexColor(@"#9B9B9B");
    [self.arrowButton setImage:[UIImage imageNamed:@"mine_icon_membership_arrow"] forState:UIControlStateNormal];
    [self.arrowButton setImage:[UIImage imageNamed:@"mine_icon_membership_arrow_highlight"] forState:UIControlStateHighlighted];
    self.arrowButton.imageView.contentMode = UIViewContentModeRight;
    self.line.backgroundColor = kBaseViewControllerBackgroundColor;
    self.statusCountLabel.baseString = @"微博";
    self.attentionCountLabel.baseString = @"关注";
    self.funsCountLabel.baseString = @"粉丝";
    self.statusCountLabel.numberOfLines = 0;
    self.attentionCountLabel.numberOfLines = 0;
    self.funsCountLabel.numberOfLines = 0;
    
    self.tag = WBMeHeaderViewClickTypeMeDetail;
    self.statusCountLabel.tag = WBMeHeaderViewClickTypeStatus;
    self.attentionCountLabel.tag = WBMeHeaderViewClickTypeAttention;
    self.funsCountLabel.tag = WBMeHeaderViewClickTypeFuns;
    
    self.statusCountLabel.userInteractionEnabled = YES;
    self.attentionCountLabel.userInteractionEnabled = YES;
    self.funsCountLabel.userInteractionEnabled = YES;
    
    SEL sel = @selector(subLabelClick:);
    self.selfTapGes = [self action:self addTapGestureRecognizerTarget:self sel:sel];
    [self action:self.statusCountLabel addTapGestureRecognizerTarget:self sel:sel];
    [self action:self.attentionCountLabel addTapGestureRecognizerTarget:self sel:sel];
    [self action:self.funsCountLabel addTapGestureRecognizerTarget:self sel:sel];
    
}

- (void)subLabelClick:(UITapGestureRecognizer *)tapGes
{
    if ([self.delegate respondsToSelector:@selector(headerView:didClickType:)]) {
        [self.delegate headerView:self didClickType:tapGes.view.tag];
    }
}

- (UITapGestureRecognizer *)action:(UIView *)actionView addTapGestureRecognizerTarget:(id)target sel:(SEL)selector
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [actionView addGestureRecognizer:tapGes];
    return tapGes;
}

- (void)setUser:(WBUser *)user
{
    _user = user;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"sign-up_avatar_default"]];
    self.nameLabel.text = user.name;
    self.desLabel.text = user.des;
    self.statusCountLabel.text = [NSString stringWithFormat:@"%ld", user.statuses_count.integerValue];
    self.attentionCountLabel.text = [NSString stringWithFormat:@"%ld", user.friends_count.integerValue];
    self.funsCountLabel.text = [NSString stringWithFormat:@"%ld", user.followers_count.integerValue];
}

- (IBAction)arrowClick {
    [self subLabelClick:self.selfTapGes];
}

@end

@implementation WBMeHeaderViewLabel

- (void)setText:(NSString *)text
{
    if (self.baseString == nil) {
        [super setText:text];
    } else {
        NSString *combineStr = [NSString stringWithFormat:@"%@\n%@", text, self.baseString];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:combineStr];
        [attStr setAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} range:[combineStr rangeOfString:text]];
        [attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.5], NSForegroundColorAttributeName : kCSSHexColor(@"#9B9B9B")} range:[combineStr rangeOfString:self.baseString]];
        self.attributedText = attStr;
    }
}


@end
