//
//  WBHomeMenuCell.h
//  WeiBo
//
//  Created by wbs on 17/3/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBHomeMenuCell;
@class WBHomeMenuItem;

@protocol WBHomeMenuCellDelegate <NSObject>

@required
- (void)homeMenuCell:(WBHomeMenuCell *)cell didClickButtonWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface WBHomeMenuCell : UITableViewCell

+ (__kindof WBHomeMenuCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) WBHomeMenuItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<WBHomeMenuCellDelegate> delegate;

@end
