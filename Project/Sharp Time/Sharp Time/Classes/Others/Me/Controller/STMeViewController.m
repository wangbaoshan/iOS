//
//  STMeViewController.m
//  Sharp Time
//
//  Created by power on 2017/4/20.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STMeViewController.h"

#import "STMeHeaderView.h"
#import "UserRecord+CoreDataClass.h"
#import "UserInfo+CoreDataClass.h"
#import "Hub.h"
#import "STLoginMgr.h"
#import "STErrorMgr.h"
#import "LoginViewController.h"
#import "STSettingGroup.h"
#import "STSettingItem.h"
#import "STSettingCell.h"
#import "STAccountViewController.h"
#import "STSelfCenterViewController.h"
#import "STCommonViewController.h"

#import "LabHomeViewController.h"

@interface STMeViewController () <UITableViewDataSource, UITableViewDelegate, STMeHeaderViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) STMeHeaderView *headerView;
@property (nonatomic, weak) UIImagePickerController *imagePicker;
@property (nonatomic, strong) NSMutableArray<STSettingGroup *> *groups;

@end

@implementation STMeViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createData];
    
    [self loadUI];
    
    [self loadData];
}

- (void)createData
{
    STSettingGroup *group0 = [[STSettingGroup alloc] init];
    STSettingItem *item00 = [[STSettingItem alloc] init];
    item00.title = @"账号管理";
    item00.type = STSettingItemTypeArrow;
    STSettingItem *item01 = [[STSettingItem alloc] init];
    item01.title = @"个人中心";
    item01.type = STSettingItemTypeArrow;
    group0.items = @[item00, item01];
    
    STSettingGroup *group1 = [[STSettingGroup alloc] init];
    STSettingItem *item10 = [[STSettingItem alloc] init];
    item10.title = @"通用";
    item10.type = STSettingItemTypeArrow;
    group1.items = @[item10];
    
    STSettingGroup *group2 = [[STSettingGroup alloc] init];
    group2.footerTitle = @"提供一些探索中的iOS效果";
    STSettingItem *item20 = [[STSettingItem alloc] init];
    item20.title = @"实验室";
    item20.type = STSettingItemTypeArrow;
    group2.items = @[item20];
    
    [self.groups addObject:group0];
    [self.groups addObject:group1];
    [self.groups addObject:group2];
}

- (void)loadUI
{
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    STMeHeaderView *headerView = [STMeHeaderView headerView];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}

- (void)loadData
{
    id<ILoginMgr> loginMgr = [Hub getLoginMgr];
    UserInfo *userInfo = [loginMgr userInfoWithUserName:loginMgr.currentLoginUserName];
    self.headerView.userInfo = userInfo;
}

#pragma mark - Getter

- (NSMutableArray<STSettingGroup *> *)groups
{
    if (!_groups) {
        _groups = [NSMutableArray arrayWithCapacity:0];
    }
    return _groups;
}

#pragma mark - STMeHeaderViewDelegate

- (void)headerView:(STMeHeaderView *)headerView didClickIconView:(UIImageView *)iconView
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"编辑我的头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self presentMessageTips:@"该设备不支持拍照功能"];
        } else {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker = imagePicker;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker = imagePicker;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if (self.imagePicker == picker) {
        UIImage *newPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
        id<ILoginMgr> loginMgr = [Hub getLoginMgr];
        [loginMgr editMyIconWithUserName:loginMgr.currentLoginUserName image:newPhoto completeBlock:^(UIImage *image, STError *error) {
            if (error) {
                [self presentFailureTips:error.errorTip];
            } else {
                [self loadData];
            }
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
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
    STSettingCell *cell = [STSettingCell cellWithTableView:tableView];
    cell.item = self.groups[indexPath.section].items[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { // 账号管理
            STAccountViewController *accountVC = [[STAccountViewController alloc] init];
            [self.navigationController pushViewController:accountVC animated:YES];
        } else if (indexPath.row == 1) { // 个人中心
            STSelfCenterViewController *selfCenterVC = [[STSelfCenterViewController alloc] init];
            [self.navigationController pushViewController:selfCenterVC animated:YES];
        } else { // 其他
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) { // 通用
            STCommonViewController *commonVC = [[STCommonViewController alloc] init];
            [self.navigationController pushViewController:commonVC animated:YES];
        } else { // 其他
            
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) { // 实验室
            LabHomeViewController *labHomeVC = [[LabHomeViewController alloc] init];
            [self.navigationController pushViewController:labHomeVC animated:YES];
        } else { // 其他
            
        }
    } else {
        
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


@end
