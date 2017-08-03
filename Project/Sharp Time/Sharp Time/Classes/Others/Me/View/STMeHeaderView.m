//
//  STMeHeaderView.m
//  Sharp Time
//
//  Created by power on 2017/5/18.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STMeHeaderView.h"

#import "UserInfo+CoreDataClass.h"

@interface STMeHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation STMeHeaderView

+ (STMeHeaderView *)headerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconView.layer.cornerRadius = 5.0;
    self.iconView.clipsToBounds = YES;
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconView)]];
}

- (void)clickIconView
{
    if ([self.delegate respondsToSelector:@selector(headerView:didClickIconView:)]) {
        [self.delegate headerView:self didClickIconView:self.iconView];
    }
}

- (void)setUserInfo:(UserInfo *)userInfo
{
    _userInfo = userInfo;
    
    self.iconView.image = [UIImage imageWithData:userInfo.userIcon];
    self.nameLabel.text = userInfo.userName;
}

@end

@implementation STIconImageView

- (void)setImage:(UIImage *)image
{
    if (image != nil) {
        [super setImage:image];
    }
}

@end
