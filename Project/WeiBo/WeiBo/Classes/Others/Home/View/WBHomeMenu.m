//
//  WBHomeMenu.m
//  WeiBo
//
//  Created by wbs on 17/3/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeMenu.h"

#import "WBHomeMenuGroup.h"
#import "WBHomeMenuItem.h"
#import "WBHomeMenuCell.h"
#import "WBHomeMenuHeaderView.h"

@interface WBHomeMenu () <UITableViewDataSource, UITableViewDelegate, WBHomeMenuCellDelegate>

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIImageView *bgView;
@property (nonatomic, weak) UITableView *contentTableView;

@end

@implementation WBHomeMenu

- (void)dealloc
{
    kWBLogMothodFunc;
}

+ (WBHomeMenu *)menu
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        
        UIView *totalView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:totalView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [totalView addGestureRecognizer:tap];
        
        UIView *containerView = [[UIView alloc] init];
        containerView.frame = CGRectMake(0, 64 - 9, self.width * 0.55, self.height * 0.5);
        containerView.centerX = self.centerX;
        [self addSubview:containerView];
        self.containerView = containerView;
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:containerView.bounds];
        bgView.userInteractionEnabled = YES;
        bgView.image = [UIImage resizedImageWithImageStr:@"popover_background"];
        [containerView addSubview:bgView];
        self.bgView = bgView;
        
        UITableView *contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 15, bgView.width - 5 * 2, bgView.height - 15 - 10) style:UITableViewStyleGrouped];
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        contentTableView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:contentTableView];
        self.contentTableView = contentTableView;
        
    }
    return self;
}

- (void)show
{
    self.alpha = 0.0;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Setter

- (void)setDefaultSelectedIndexPath:(NSIndexPath *)defaultSelectedIndexPath
{
    _defaultSelectedIndexPath = defaultSelectedIndexPath;
    [self.contentTableView selectRowAtIndexPath:defaultSelectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)setAlignmentType:(WBHomeMenuAlignmentType)alignmentType
{
    _alignmentType = alignmentType;
    
    switch (alignmentType) {
        case WBHomeMenuAlignmentTypeCenter:
            
            break;
        case WBHomeMenuAlignmentTypeLeft:
            self.containerView.x = 0;
            self.containerView.width = self.width * 0.4;
            self.bgView.image = [UIImage resizedImageWithImageStr:@"popover_background_left"];
            break;
        case WBHomeMenuAlignmentTypeRight:
            self.containerView.width = self.width * 0.4;
            self.containerView.x = self.width - self.containerView.width;
            self.bgView.image = [UIImage resizedImageWithImageStr:@"popover_background_right"];
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBHomeMenuCell *cell = [WBHomeMenuCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    kWBLog(@"section=%ld, row = %ld", indexPath.section, indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.groups[section].groupTitle) {
        return 20;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WBHomeMenuGroup *group = self.groups[section];
    if (group.groupTitle) {
        WBHomeMenuHeaderView *headerView = [WBHomeMenuHeaderView headerViewWithTableView:tableView];
        headerView.group = group;
        return headerView;
    } else {
        return nil;
    }
}

#pragma mark - WBHomeMenuCellDelegate

- (void)homeMenuCell:(WBHomeMenuCell *)cell didClickButtonWithIndexPath:(NSIndexPath *)indexPath
{
    self.defaultSelectedIndexPath = indexPath;
    [self tableView:self.contentTableView didSelectRowAtIndexPath:indexPath];
}

@end



