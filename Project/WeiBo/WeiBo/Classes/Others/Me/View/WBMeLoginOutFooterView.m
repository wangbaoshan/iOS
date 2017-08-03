//
//  WBMeLoginOutFooterView.m
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBMeLoginOutFooterView.h"

@interface WBMeLoginOutFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginOutButton;
- (IBAction)loginOut;

@end

@implementation WBMeLoginOutFooterView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

+ (WBMeLoginOutFooterView *)loginOutFooterView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.loginOutButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.loginOutButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [self.loginOutButton setTitleColor:kCSSHexColor(@"#E14223") forState:UIControlStateNormal];
    [self.loginOutButton setBackgroundImage:[UIImage imageWithColor:kBaseViewControllerBackgroundColor alpha:1.0] forState:UIControlStateHighlighted];
}

- (IBAction)loginOut {
    if ([self.delegate respondsToSelector:@selector(footerViewDidClickLoginOut:)]) {
        [self.delegate footerViewDidClickLoginOut:self];
    }
}
@end
