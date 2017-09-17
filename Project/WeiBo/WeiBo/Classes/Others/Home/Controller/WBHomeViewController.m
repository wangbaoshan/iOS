//
//  WBHomeViewController.m
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeViewController.h"

#import "WBUserContentParamter.h"
#import "WBUserContentResult.h"
#import "WBHomeStatusesParamter.h"
#import "WBHomeStatusesResult.h"
#import "WBStatus.h"
#import "WBStatusFrame.h"
#import "WBStatusCell.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBHomeTitleButton.h"
#import "WBPhotoBrowser.h"
#import "WBHomeMenu.h"
#import "WBHomeMenuGroup.h"
#import "WBHomeMenuItem.h"

#import "BSPhotoBrowser.h"
#import "WBStatusPhotosView.h"

#define kPageSize 20

@interface WBHomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<WBStatusFrame *> *statusFrames;
@property (nonatomic, strong) WBHomeTitleButton *titleBtn;
@property (nonatomic, strong) WBHomeMenu *menu;

@end

@implementation WBHomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter

- (WBHomeMenu *)menu
{
    if (_menu == nil) {
        _menu = [WBHomeMenu menu];
        _menu.alignmentType = WBHomeMenuAlignmentTypeCenter;
        
        WBHomeMenuGroup *group0 = [[WBHomeMenuGroup alloc] init];
        WBHomeMenuItem *item00 = [[WBHomeMenuItem alloc] init];
        item00.itemName = @"首页";
        WBHomeMenuItem *item01 = [[WBHomeMenuItem alloc] init];
        item01.itemName = @"好友圈";
        item01.imageString = @"friendcircle_popover_cell_friendcircle";
        item01.selectedImageString = @"friendcircle_popover_cell_friendcircle_highlighted";
        WBHomeMenuItem *item02 = [[WBHomeMenuItem alloc] init];
        item02.itemName = @"群微博";
        group0.items = @[item00, item01, item02];
        
        WBHomeMenuGroup *group1 = [[WBHomeMenuGroup alloc] init];
        group1.groupTitle = @"我的分组";
        WBHomeMenuItem *item10 = [[WBHomeMenuItem alloc] init];
        item10.itemName = @"特别关注";
        WBHomeMenuItem *item11 = [[WBHomeMenuItem alloc] init];
        item11.itemName = @"旅游";
        WBHomeMenuItem *item12 = [[WBHomeMenuItem alloc] init];
        item12.itemName = @"同学";
        WBHomeMenuItem *item13 = [[WBHomeMenuItem alloc] init];
        item13.itemName = @"名人明星";
        WBHomeMenuItem *item14 = [[WBHomeMenuItem alloc] init];
        item14.itemName = @"同事";
        WBHomeMenuItem *item15 = [[WBHomeMenuItem alloc] init];
        item15.itemName = @"搞笑";
        WBHomeMenuItem *item16 = [[WBHomeMenuItem alloc] init];
        item16.itemName = @"悄悄关注";
        group1.items = @[item10, item11, item12, item13, item14, item15, item16];
        
        WBHomeMenuGroup *group2 = [[WBHomeMenuGroup alloc] init];
        group2.groupTitle = @"其他";
        WBHomeMenuItem *item20 = [[WBHomeMenuItem alloc] init];
        item20.itemName = @"周边微博";
        group2.items = @[item20];
        _menu.groups = @[group0, group1, group2];
        
        NSInteger row = [group0.items indexOfObject:item00];
        NSInteger section = [_menu.groups indexOfObject:group0];
        _menu.defaultSelectedIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
        
    }
    return _menu;
}

- (NSMutableArray<WBStatusFrame *> *)statusFrames
{
    if (_statusFrames == nil) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (WBHomeTitleButton *)titleBtn
{
    if (_titleBtn == nil) {
        _titleBtn = [WBHomeTitleButton titleButton];
        _titleBtn.bounds = CGRectMake(0, 0, 0, 30);
        [_titleBtn setBackgroundImage:[UIImage resizedImageWithImageStr:@"timeline_card_top_background_highlighted"] forState:UIControlStateHighlighted];
        [_titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    [self loadUI];
    
    // Internet
    [self getCurrentUserContent];
    [self remoteHomeStatus];
    
    // Observer
    [self addNotificationObsever];
}

- (void)remoteHomeStatus
{
    [self.view presentLoadingTips:nil];
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    WBHomeStatusesParamter *param = [WBHomeStatusesParamter param];
    param.count = @(kPageSize);
    [WBNetAPIBusiness homeStatuses:param completion:^(WBHomeStatusesResult *result, NSError *error) {
        if (error) {
            
        } else {
            NSArray *frames = [self statusFramesWithStatuses:result.statuses];
            NSRange range = NSMakeRange(0, frames.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.statusFrames insertObjects:frames atIndexes:indexSet];
            
            [self.tableView reloadData];
        }
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = !self.statusFrames.count;
        [self.view dismissTips];
    }];
}

- (void)loadUI
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_friendattention" highlightImageName:@"navigationbar_friendattention_highlighted" target:self action:@selector(attention)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImageName:@"navigationbar_icon_radar" highlightImageName:@"navigationbar_icon_radar_highlighted" target:self action:@selector(radar)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
}

- (void)loadNewData
{
    self.tableView.mj_footer.hidden = YES;
    // 新浪微博数据从上到下id按由大到小排列
    WBHomeStatusesParamter *param = [WBHomeStatusesParamter param];
    param.count = @(kPageSize);
    param.since_id = self.statusFrames.firstObject.status.idNum;
    [WBNetAPIBusiness homeStatuses:param completion:^(WBHomeStatusesResult *result, NSError *error) {
        if (error) {
            [self.view presentMessageTips:error.localizedDescription];
        } else {
            if (result.statuses.count == 0) {
                [self.view presentMessageTips:@"没有最新微博"];
            } else {
                NSArray *newFrames = [self statusFramesWithStatuses:result.statuses];
                NSRange range = NSMakeRange(0, newFrames.count);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [self.statusFrames insertObjects:newFrames atIndexes:indexSet];
                
                if (self.statusFrames.count > 20) {
                    range = NSMakeRange(19, self.statusFrames.count - 20);
                    indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                    [self.statusFrames removeObjectsAtIndexes:indexSet];
                }
                
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        self.tableView.mj_footer.hidden = !self.statusFrames.count;
    }];
}

- (void)loadMoreData
{
    self.tableView.mj_header.hidden = YES;
    WBHomeStatusesParamter *param = [WBHomeStatusesParamter param];
    param.count = @(15);
    param.max_id = @(self.statusFrames.lastObject.status.idNum.longLongValue - 1);
    [WBNetAPIBusiness homeStatuses:param completion:^(WBHomeStatusesResult *result, NSError *error) {
        if (error) {
            
        } else {
            NSArray *newFrames = [self statusFramesWithStatuses:result.statuses];
            NSRange range = NSMakeRange(self.statusFrames.count, newFrames.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.statusFrames insertObjects:newFrames atIndexes:indexSet];
            
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
    }];
}

- (void)getCurrentUserContent
{
    WBAccount *account = [WBAccountTool account];
    if (account.user) {
        [self refreshTitle:account.user];
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
            [self refreshTitle:result]; // 刷新title
            account.user = result;
            [WBAccountTool archieveAccount:account];
        }
    }];
}

- (void)refreshTitle:(WBUser *)result
{
    self.navigationItem.titleView = nil;
    NSString *titleStr = result.name ? result.name : @"首页";
    [self.titleBtn setTitle:titleStr forState:UIControlStateNormal];
    [self.titleBtn setImage:[UIImage imageNamed:@"timeline_icon_more_highlighted"] forState:UIControlStateNormal];
    self.navigationItem.titleView = self.titleBtn;
}

- (void)addNotificationObsever
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStatusBar) name:kWBPhotoBrowserShouldHideStatusBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visialStatusBar) name:kWBPhotoBrowserShouldNotHideStatusBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickPhoto:) name:kStatusPhotosViewDidClickPhoto object:nil];
}

- (void)clickPhoto:(NSNotification *)noti
{
//    NSLog(@"%@", noti.object);
    BSPhotoBrowser *browser = noti.object;
    [browser showViewController:self];
}

- (void)removeNotificationObsever
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWBPhotoBrowserShouldHideStatusBar object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWBPhotoBrowserShouldNotHideStatusBar object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kStatusPhotosViewDidClickPhoto object:nil];
}

- (void)hideStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
- (void)visialStatusBar
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)click:(UIButton *)btn
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSArray *)statusFramesWithStatuses:(NSArray<WBStatus *> *)statuses
{
    NSMutableArray *statusFrames = [NSMutableArray array];
    for (WBStatus *status in statuses) {
        WBStatusFrame *statusFrame = [[WBStatusFrame alloc] init];
        statusFrame.status = status;
        [statusFrames addObject:statusFrame];
    }
    return statusFrames;
}


- (void)attention
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)radar
{
    
}

- (void)titleBtnClick  
{
    [self.menu show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBStatusCell *cell = [WBStatusCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.statusFrames[indexPath.row].cellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
