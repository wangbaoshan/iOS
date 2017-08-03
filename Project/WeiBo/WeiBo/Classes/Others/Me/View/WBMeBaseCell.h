//
//  WBMeBaseCell.h
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBMeItem;

@interface WBMeBaseCell : UITableViewCell
{
    @public
    WBMeItem *_item;
    
    @protected
    UISwitch *_switchView;
    UIImageView *_arrowView;
    UIImageView *_pointView;
}

@property (nonatomic, strong) WBMeItem *item;

@property (nonatomic, strong, readonly) UISwitch *switchView;
@property (nonatomic, strong, readonly) UIImageView *arrowView;
@property (nonatomic, strong, readonly) UIImageView *pointView;

+ (__kindof WBMeBaseCell *)cellWithTableView:(UITableView *)tableView;

@end
