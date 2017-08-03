//
//  WBMeBaseCell.m
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBMeBaseCell.h"

#import "WBMeItem.h"

@interface WBMeBaseCell ()

@end

@implementation WBMeBaseCell

+ (WBMeBaseCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"setting";
    WBMeBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)setItem:(WBMeItem *)item
{
    _item = item;
    
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.content;
    
    if (item.type == WBMeItemTypeArrow) {
        self.accessoryView = [self arrowView];
    } else if (item.type == WBMeItemTypeSwitch) {
        self.accessoryView = [self switchView];
    } else if (item.type == WBMeItemTypePoint) {
        self.accessoryView = [self pointView];
    } else {
        self.accessoryView = nil;
    }
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SignIn_arrow"]];
    }
    return _arrowView;
}

- (UIImageView *)pointView
{
    if (_pointView == nil) {
        _pointView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"half_compose_dot_background"]];
    }
    return _pointView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

