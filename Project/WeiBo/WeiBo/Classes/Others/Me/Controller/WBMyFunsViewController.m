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
#import "WBMyFunCell.h"

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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.tableView.mj_header = header;
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.tableView.mj_footer = footer;
    
    [self.view presentLoadingTips:nil];
    WBMyFunsParameter *param = [WBMyFunsParameter param];
    NSString *uid = [WBAccountTool uid];
    param.uid = @(uid.longLongValue);
    param.trim_status = @(0);
    [WBNetAPIBusiness myFuns:param completion:^(WBMyFunsResult *result, NSError *error) {
        [self.view dismissTips];
        if (error) {
            [self.view presentFailureTips:error.localizedDescription];
        } else {
            [self.myFuns addObjectsFromArray:result.users];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadNewData
{
    
}

- (void)loadMoreData
{
    
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
    WBMyFunCell *cell = [WBMyFunCell cellWithTableView:tableView];
    cell.myFun = self.myFuns[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.myFuns.count) {
        return @"全部粉丝";
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kWBMyFunCellHeight;
}

@end
