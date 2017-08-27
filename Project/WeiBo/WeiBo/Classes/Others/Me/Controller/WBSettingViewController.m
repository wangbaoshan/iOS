//
//  WBSettingViewController.m
//  WeiBo
//
//  Created by wbs on 17/3/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBSettingViewController.h"

#import "WBMeLoginOutFooterView.h"
#import "WBMeGroup.h"
#import "WBMeItem.h"
#import "WBSettingCell.h"
#import "WBSettingCacheCell.h"

@interface WBSettingViewController () <UITableViewDataSource, UITableViewDelegate, WBMeLoginOutFooterViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBMeGroup *> *groups;

@end

@implementation WBSettingViewController

- (void)dealloc
{
    kWBLogMothodFunc;
}

- (NSMutableArray<WBMeGroup *> *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    [self loadUI];
}

- (void)loadUI
{
    self.navigationItem.title = @"设置";
    
    [self createDataSource];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 15, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WBMeLoginOutFooterView *footerView = [WBMeLoginOutFooterView loginOutFooterView];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;
    
}

- (void)createDataSource
{
    WBMeGroup *group0 = [WBMeGroup group];
    WBMeItem *item00 = [WBMeItem item];
    item00.title = @"账号管理";
    item00.type = WBMeItemTypeArrow;
    WBMeItem *item01 = [WBMeItem item];
    item01.title = @"账号安全";
    item01.type = WBMeItemTypeArrow;
    group0.items = @[item00, item01];
    [self.groups addObject:group0];
    
    WBMeGroup *group1 = [WBMeGroup group];
    WBMeItem *item10 = [WBMeItem item];
    item10.title = @"消息设置";
    item10.type = WBMeItemTypeArrow;
    WBMeItem *item11 = [WBMeItem item];
    item11.title = @"屏蔽设置";
    item11.type = WBMeItemTypeArrow;
    WBMeItem *item12 = [WBMeItem item];
    item12.title = @"隐私";
    item12.type = WBMeItemTypeArrow;
    WBMeItem *item13 = [WBMeItem item];
    item13.title = @"通用设置";
    item13.type = WBMeItemTypeArrow;
    group1.items = @[item10, item11, item12, item13];
    [self.groups addObject:group1];
    
    WBMeGroup *group2 = [WBMeGroup group];
    WBMeItem *item20 = [WBMeItem item];
    item20.title = @"清除缓存";
    item20.type = WBMeItemTypeArrow;
    WBMeItem *item21 = [WBMeItem item];
    item21.title = @"护眼模式";
    item21.type = WBMeItemTypeSwitch;
    WBMeItem *item22 = [WBMeItem item];
    item22.title = @"意见反馈";
    item22.type = WBMeItemTypeArrow;
    WBMeItem *item23 = [WBMeItem item];
    item23.title = @"客服中心";
    item23.type = WBMeItemTypeArrow;
    WBMeItem *item24 = [WBMeItem item];
    item24.title = @"关于微博";
    item24.type = WBMeItemTypeArrow;
    group2.items = @[item20, item21, item22, item23, item24];
    [self.groups addObject:group2];
}

#pragma mark - WBMeLoginOutFooterViewDelegate

- (void)footerViewDidClickLoginOut:(WBMeLoginOutFooterView *)footerView
{
    
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
    WBMeItem *item = self.groups[indexPath.section].items[indexPath.row];
    if ([item.title isEqualToString:@"清除缓存"]) {
        WBSettingCacheCell *cacheCell = [WBSettingCacheCell cellWithTableView:tableView];
        cacheCell.item = item;
        return cacheCell;
    } else {
        WBSettingCell *cell = [WBSettingCell cellWithTableView:tableView];
        cell.item = item;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WBMeItem *item = self.groups[indexPath.section].items[indexPath.row];
    if ([item.title isEqualToString:@"清除缓存"]) {
        WBSettingCacheCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.isCalculating) {
            
        } else {
            [cell clearCache];
        }
    } else {
        kWBLog(@"section=%ld, row = %ld", indexPath.section, indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 15;
    } else {
        return 0.01;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
