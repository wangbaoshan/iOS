//
//  WBHomeMenuHeaderView.m
//  WeiBo
//
//  Created by wbs on 17/3/9.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeMenuHeaderView.h"
#import "WBHomeMenuGroup.h"

@interface WBHomeMenuHeaderView ()

@property (nonatomic, weak) UIView *lineLeft;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIView *lineRight;

@end

static CGFloat const margin = 3.0;

@implementation WBHomeMenuHeaderView

+ (WBHomeMenuHeaderView *)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *headerID = @"menuHeader";
    WBHomeMenuHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!headerView) {
        headerView = [[self alloc] initWithReuseIdentifier:headerID];
    }
    return headerView;
}  

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(margin, 10, 15, 0.3)];
        [self.contentView addSubview:lineLeft];
        self.lineLeft = lineLeft;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.lineLeft.frame) + margin, 0, 0, 20)];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 0, 0.3)];
        [self.contentView addSubview:lineRight];
        self.lineRight = lineRight;
        
        self.lineLeft.backgroundColor = kCSSHexColor(@"#383838");
        self.lineRight.backgroundColor = kCSSHexColor(@"#383838");
        self.nameLabel.textColor = kCSSHexColor(@"#383838");
        self.nameLabel.font = [UIFont systemFontOfSize:11];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)setGroup:(WBHomeMenuGroup *)group
{
    _group = group;
    
    self.nameLabel.text = group.groupTitle;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self.group.groupTitle sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]}];
    self.nameLabel.width = size.width;
    self.lineRight.x = CGRectGetMaxX(self.nameLabel.frame) + margin;
    self.lineRight.width = self.width - margin - self.lineRight.x;
}



@end
