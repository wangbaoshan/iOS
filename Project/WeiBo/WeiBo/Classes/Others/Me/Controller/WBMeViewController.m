//
//  WBMeViewController.m
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBMeViewController.h"

#import "WBAddFriendsViewController.h"
#import "WBSettingViewController.h"
#import "WBMeDetailViewController.h"
#import "WBMeHeaderView.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBUserContentParamter.h"
#import "WBUserContentResult.h"
#import "WBMeGroup.h"
#import "WBMeItem.h"
#import "WBMeCell.h"
#import "WBMyFunsViewController.h"

@interface WBMeViewController () <UITableViewDataSource, UITableViewDelegate, WBMeHeaderViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBMeGroup *> *groups;

@end

@implementation WBMeViewController

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
    
    //
    [self getCurrentUserContent];
}

- (void)loadUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加好友" style:UIBarButtonItemStyleDone target:self action:@selector(addFriends)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(setting)];
    
    [self createDataSource];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WBMeHeaderView *headerView = [WBMeHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 160);
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = kSystemNavigationBarLineColor.CGColor;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
}

- (void)createDataSource
{
    WBMeGroup *group0 = [WBMeGroup group];
    WBMeItem *item00 = [WBMeItem item];
    item00.title = @"新的朋友";
    item00.type = WBMeItemTypeArrow;
    group0.items = @[item00];
    [self.groups addObject:group0];
    
    WBMeGroup *group1 = [WBMeGroup group];
    WBMeItem *item10 = [WBMeItem item];
    item10.title = @"我的相册";
    item10.type = WBMeItemTypeArrow;
    WBMeItem *item11 = [WBMeItem item];
    item11.title = @"我的赞";
    item11.type = WBMeItemTypeArrow;
    group1.items = @[item10, item11];
    [self.groups addObject:group1];
    
    WBMeGroup *group2 = [WBMeGroup group];
    WBMeItem *item20 = [WBMeItem item];
    item20.title = @"微博钱包";
    item20.content = @"逛好物，享红包";
    item20.type = WBMeItemTypeArrow;
    WBMeItem *item21 = [WBMeItem item];
    item21.title = @"微博运动";
    item21.content = @"每天10000步，你达标了吗？";
    item21.type = WBMeItemTypePoint;
    WBMeItem *item22 = [WBMeItem item];
    item22.title = @"微博微卡";
    item22.content = @"限量申请，微博免流量任性刷";
    item22.type = WBMeItemTypeArrow;
    group2.items = @[item20, item21, item22];
    [self.groups addObject:group2];
    
    WBMeGroup *group3 = [WBMeGroup group];
    WBMeItem *item30 = [WBMeItem item];
    item30.title = @"草稿箱";
    item30.type = WBMeItemTypeArrow;
    group3.items = @[item30];
    [self.groups addObject:group3];
    
    WBMeGroup *group4 = [WBMeGroup group];
    WBMeItem *item40 = [WBMeItem item];
    item40.title = @"更多";
    item40.content = @"收藏";
    item40.type = WBMeItemTypeArrow;
    group4.items = @[item40];
    [self.groups addObject:group4];
}

- (void)addFriends
{
    WBAddFriendsViewController *addFriendsVC = [[WBAddFriendsViewController alloc] init];
    addFriendsVC.backBarItemString = [self.navigationItem.title copy];
    [self.navigationController pushViewController:addFriendsVC animated:YES];
}

- (void)setting
{
    WBSettingViewController *settingVC = [[WBSettingViewController alloc] init];
    settingVC.backBarItemString = [self.navigationItem.title copy];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)meDetail
{
    WBMeDetailViewController *meDetailVC = [[WBMeDetailViewController alloc] init];
    meDetailVC.backBarItemString = [self.navigationItem.title copy];
    [self.navigationController pushViewController:meDetailVC animated:YES];
}

- (void)meStatus
{
    
}

- (void)meAttention
{
    
}

- (void)meFuns
{
    WBMyFunsViewController *myFunsVC = [[WBMyFunsViewController alloc] init];
    myFunsVC.backBarItemString = [self.navigationItem.title copy];
    [self.navigationController pushViewController:myFunsVC animated:YES];
}


- (void)getCurrentUserContent
{
    WBAccount *account = [WBAccountTool account];
    if (account.user) {
        [self refreshHeaderView:account.user];
    } else {
        [self remoteCurrentUserContent:account];
    }
}

- (void)remoteCurrentUserContent:(WBAccount *)account
{
    WBUserContentParamter *param = [WBUserContentParamter param];
    param.uid = account.uid;
    [WBNetAPIBusiness currentUserContent:param completion:^(WBUserContentResult *result, NSError *error) {
        if (error) {
            
        } else {
            [self refreshHeaderView:result];
            account.user = result;
            [WBAccountTool archieveAccount:account];
        }
    }];
}

- (void)refreshHeaderView:(WBUser *)result
{
    WBMeHeaderView *headerView = (WBMeHeaderView *)self.tableView.tableHeaderView;
    headerView.user = result;
}

#pragma mark - WBMeHeaderViewDelegate

- (void)headerView:(WBMeHeaderView *)headerView didClickType:(WBMeHeaderViewClickType)type
{
    switch (type) {
        case WBMeHeaderViewClickTypeMeDetail:
        {
            [self meDetail];
        }
            break;
        case WBMeHeaderViewClickTypeStatus:
        {
            [self meStatus];
        }
            break;
        case WBMeHeaderViewClickTypeAttention:
        {
            [self meAttention];
        }
            break;
        case WBMeHeaderViewClickTypeFuns:
        {
            [self meFuns];
        }
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
    WBMeCell *cell = [WBMeCell cellWithTableView:tableView];
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kWBLog(@"section=%ld, row = %ld", indexPath.section, indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
