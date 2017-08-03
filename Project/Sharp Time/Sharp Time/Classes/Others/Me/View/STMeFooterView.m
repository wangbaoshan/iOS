//
//  STMeFooterView.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STMeFooterView.h"

@interface STMeFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *exitLoginButton;

- (IBAction)exitLogin;

@end

@implementation STMeFooterView

+ (STMeFooterView *)footerView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.exitLoginButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.exitLoginButton setTitle:@"退出当前帐号" forState:UIControlStateNormal];
    [self.exitLoginButton setTitle:@"退出当前帐号" forState:UIControlStateHighlighted];
    [self.exitLoginButton setTitleColor:kSystemNavigationItemNormalColor forState:UIControlStateNormal];
    [self.exitLoginButton setTitleColor:kSystemNavigationItemHighlightColor forState:UIControlStateHighlighted];
    
}

- (IBAction)exitLogin {
    if ([self.delegate respondsToSelector:@selector(footerView:didClickLoginOutButton:)]) {
        [self.delegate footerView:self didClickLoginOutButton:self.exitLoginButton];
    }
}
@end
