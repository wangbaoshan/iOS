//
//  STSettingCell.h
//  Sharp Time
//
//  Created by power on 2017/6/8.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STSettingItem;

@interface STSettingCell : UITableViewCell

+ (__kindof STSettingCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) STSettingItem *item;

@end
