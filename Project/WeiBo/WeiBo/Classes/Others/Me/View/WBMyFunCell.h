//
//  WBMyFunCell.h
//  WeiBo
//
//  Created by bao on 2017/8/28.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWBMyFunCellHeight 85.0f
#define kWBMyFunCellIconViewHeight (kWBMyFunCellHeight - 8 * 2)

@class WBMyFun;

@interface WBMyFunCell : UITableViewCell

+ (__kindof WBMyFunCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) WBMyFun *myFun;
@property (nonatomic, assign, getter=isAttentioned) BOOL attentioned;

@end
