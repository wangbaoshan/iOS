//
//  WBHomeMenuHeaderView.h
//  WeiBo
//
//  Created by wbs on 17/3/9.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBHomeMenuGroup;

@interface WBHomeMenuHeaderView : UITableViewHeaderFooterView

+ (__kindof WBHomeMenuHeaderView *)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) WBHomeMenuGroup *group;

@end
