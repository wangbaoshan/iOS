//
//  WBStatusCell.h
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBStatusFrame;

@interface WBStatusCell : UITableViewCell

@property (nonatomic, strong) WBStatusFrame *statusFrame;

+ (__kindof WBStatusCell *)cellWithTableView:(UITableView *)tableView;

@end
