//
//  WBSettingCacheCell.m
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBSettingCacheCell.h"

#import "WBMeItem.h"
#import "NSString+WBExtension.h"
#import "WBCacheTool.h"

@interface WBSettingCacheCell ()

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end

@implementation WBSettingCacheCell

- (void)dealloc
{
    kWBLogMothodFunc;
}

+ (WBSettingCacheCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"settingCache";
    WBSettingCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        
        _calculating = YES;
        
        __weak typeof(self) weakSelf = self;
        [WBCacheTool sizeWithCachePath:kWBCustomCacheFile andCaculateSDImageCache:YES owner:self complete:^(NSString *sizeString) {
            _calculating = NO;
            weakSelf.item.content = sizeString;
            [weakSelf setItem:weakSelf.item];
        }];
        
    }
    return self;
}

- (void)setItem:(WBMeItem *)item
{
    _item = item;
    
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.content;
    
    if (self.isCalculating) {
        [self activeIndicatorView];
    } else {
        [self hideIndicatorView];
        if (item.type == WBMeItemTypeArrow) {
            self.accessoryView = self.arrowView;
        } else if (item.type == WBMeItemTypeSwitch) {
            self.accessoryView = self.switchView;
        } else if (item.type == WBMeItemTypePoint) {
            self.accessoryView = self.pointView;
        } else {
            self.accessoryView = nil;
        }
    }
}

- (UIActivityIndicatorView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _loadingView;
}

- (void)activeIndicatorView
{
    self.accessoryView = self.loadingView;
    [self.loadingView startAnimating];
}

- (void)hideIndicatorView
{
    [self.loadingView stopAnimating];
    self.accessoryView = nil;
}

- (void)clearCache
{
    [SVProgressHUD showLoadingTips:@"正在清理缓存"];
    [WBCacheTool clearCachePath:kWBCustomCacheFile andClearSDImageCache:YES complete:^(NSError *error) {
        [NSThread sleepForTimeInterval:0.5];
        [SVProgressHUD dismissTips];
        if (error) {
            
        } else {
            self.item.content = @"0B";
            [self setItem:self.item];
            [SVProgressHUD showSuccessTips:@"缓存已清除"];
        }
    }];
}

@end
