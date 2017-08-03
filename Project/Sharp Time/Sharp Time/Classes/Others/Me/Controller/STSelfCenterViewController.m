//
//  STSelfCenterViewController.m
//  Sharp Time
//
//  Created by power on 2017/6/9.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STSelfCenterViewController.h"

#import "STSettingGroup.h"
#import "STSettingItem.h"
#import "STSettingCell.h"

@interface STSelfCenterViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<STSettingGroup *> *groups;

@end

@implementation STSelfCenterViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"个人中心";
    
    [self createData];
    
    [self loadUI];
}


- (void)loadUI
{
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)createData
{
    STSettingGroup *group0 = [[STSettingGroup alloc] init];
    group0.footerTitle = @"当开关设置为NO时，我的打卡记录和公司记录将不允许删除";
    STSettingItem *item00 = [[STSettingItem alloc] init];
    item00.title = @"允许删除我的打卡记录";
    item00.type = STSettingItemTypeSwitch;
    STSettingItem *item01 = [[STSettingItem alloc] init];
    item01.title = @"允许删除我的公司记录";
    item01.type = STSettingItemTypeSwitch;
    group0.items = @[item00, item01];
    
    STSettingGroup *group1 = [[STSettingGroup alloc] init];
    group1.footerTitle = @"当设置了上、下班的打卡时间，打卡操作只能在设定的时间范围内完成，否则打卡操作只能以每天中午12:00为界定";
    STSettingItem *item10 = [[STSettingItem alloc] init];
    item10.title = @"设置上班打卡时间";
    item10.type = STSettingItemTypeTextField;
    STSettingItem *item11 = [[STSettingItem alloc] init];
    item11.title = @"设置下班打卡时间";
    item11.type = STSettingItemTypeTextField;
    group1.items = @[item10, item11];
    
    [self.groups addObject:group0];
    [self.groups addObject:group1];
}

#pragma mark - Getter

- (NSMutableArray<STSettingGroup *> *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray arrayWithCapacity:0];
    }
    return _groups;
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
    STSettingCell *cell = [STSettingCell cellWithTableView:tableView];
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groups[section].headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.groups[section].footerTitle;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
