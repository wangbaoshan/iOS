//
//  LabHomeViewController.m
//  Sharp Time
//
//  Created by power on 2017/6/9.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "LabHomeViewController.h"

#import "STSettingGroup.h"
#import "STSettingItem.h"
#import "STSettingCell.h"

@interface LabHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<STSettingGroup *> *groups;

@end

@implementation LabHomeViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"实验室";
    
    [self createData];
    
    [self loadUI];
}

- (void)createData
{
    STSettingGroup *group0 = [[STSettingGroup alloc] init];
    group0.headerTitle = @"UICollectionView";
    STSettingItem *item00 = [[STSettingItem alloc] init];
    item00.title = @"效果1";
    item00.type = STSettingItemTypeArrow;
    STSettingItem *item01 = [[STSettingItem alloc] init];
    item01.title = @"效果2";
    item01.type = STSettingItemTypeArrow;
    group0.items = @[item00, item01];
    [self.groups addObject:group0];
    
    STSettingGroup *group1 = [[STSettingGroup alloc] init];
    group1.headerTitle = @"AVFoundation";
    STSettingItem *item10 = [[STSettingItem alloc] init];
    item10.title = @"效果1";
    item10.type = STSettingItemTypeArrow;
    STSettingItem *item11 = [[STSettingItem alloc] init];
    item11.title = @"效果2";
    item11.type = STSettingItemTypeArrow;
    group1.items = @[item10, item11];
    [self.groups addObject:group1];
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
    
    NSString *classString = [NSString stringWithFormat:@"DemoViewController%ld%ld", indexPath.section, indexPath.row];
    Class desVC = NSClassFromString(classString);
    if (!desVC) {
        NSLog(@"Not exist class: %@", classString);
    } else {
        UIViewController *demoVC = [[desVC alloc] init];
        [self.navigationController pushViewController:demoVC animated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groups[section].headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return self.groups[section].footerTitle;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
