//
//  STSettingCell.m
//  Sharp Time
//
//  Created by power on 2017/6/8.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STSettingCell.h"

#import "STSettingItem.h"

@interface STSettingCell ()

@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation STSettingCell

+ (STSettingCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"STSetting";
    STSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter

- (void)setItem:(STSettingItem *)item
{
    _item = item;
    
    self.textLabel.text = item.title;
    if (item.type == STSettingItemTypeArrow) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.accessoryView = nil;
    } else if (item.type == STSettingItemTypeNone) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
    } else if (item.type == STSettingItemTypeSwitch) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = self.switchView;
    } else if (item.type == STSettingItemTypeTextField) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = self.textField;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
    }
}

#pragma mark - Getter

- (UISwitch *)switchView
{
    if (!_switchView) {
        _switchView = [[UISwitch alloc] init];
    }
    return _switchView;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, 35)];
        _textField.placeholder = @"点击设置";
        _textField.textAlignment = NSTextAlignmentRight;
    }
    return _textField;
}

@end
