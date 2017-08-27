//
//  WBMyFunsViewController.m
//  WeiBo
//
//  Created by bao on 2017/8/27.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "WBMyFunsViewController.h"

#import "WBMyFunsParameter.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBMyFunsResult.h"

@interface WBMyFunsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBMyFun *> *myFuns;

@end

@implementation WBMyFunsViewController

- (NSMutableArray<WBMyFun *> *)myFuns
{
    if (!_myFuns) {
        _myFuns = [NSMutableArray arrayWithCapacity:0];
    }
    return _myFuns;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"粉丝";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.view presentLoadingTips:nil];
    WBMyFunsParameter *param = [WBMyFunsParameter param];
    NSString *uid = [WBAccountTool uid];
    param.uid = @(uid.longLongValue);
    [WBNetAPIBusiness myFuns:param completion:^(WBMyFunsResult *result, NSError *error) {
        [self.view dismissTips];
        if (error) {
            
        } else {
            [self.myFuns addObjectsFromArray:result.users];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myFuns.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"myFun";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.myFuns[indexPath.row].name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
