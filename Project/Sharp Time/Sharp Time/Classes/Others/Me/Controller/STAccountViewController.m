//
//  STAccountViewController.m
//  Sharp Time
//
//  Created by power on 2017/6/9.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STAccountViewController.h"

#import "STMeFooterView.h"
#import "Hub.h"
#import "STLoginMgr.h"
#import "STErrorMgr.h"
#import "UserRecord+CoreDataClass.h"
#import "LoginViewController.h"
#import "UserRecord+CoreDataClass.h"
#import "UserInfo+CoreDataClass.h"
#import "STNavigationController.h"

@interface STAccountViewController () <UITableViewDataSource, UITableViewDelegate, STMeFooterViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController<UserRecord *> *fetchedResultsController;

@end

@implementation STAccountViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"账号管理";
    
    [self loadUI];
    
    [self configFetchedResultsController];
    [self checkData];
}

- (void)loadUI
{
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    STMeFooterView *footerView = [STMeFooterView footerView];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 43);
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;
}

- (void)configFetchedResultsController
{
    NSFetchRequest *fetchRequest = [UserRecord fetchRequest];
    NSSortDescriptor *sortDescriptor0 = [NSSortDescriptor sortDescriptorWithKey:@"userName" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor0];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
}

- (void)checkData
{
    NSError *error = nil;
    [self.fetchedResultsController performFetch:nil];
    if (error) {
        [self.tableView reloadData];
        STLog(@"error : %@", error);
    } else {
        [self.tableView reloadData];
    }
}

- (void)cancelChange
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Getter

- (NSManagedObjectContext *)context
{
    id<ILoginMgr> loginMgr = [Hub getLoginMgr];
    return loginMgr.context;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"STAccount";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    UserRecord *userRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = userRecord.userName;
    UserInfo *userInfo = userRecord.userInfo;
    if (userInfo.currentLogin) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserRecord *userRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UserInfo *userInfo = userRecord.userInfo;
    if (!userInfo.currentLogin) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.userName = userRecord.userName;
        STNavigationController *loginNav = [[STNavigationController alloc] initWithRootViewController:loginVC];
        loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelChange)];
        [self presentViewController:loginNav animated:YES completion:nil];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
                [UIView animateWithDuration:0.3f animations:^{
                    cell.backgroundColor = kSystemNavigationItemHighlightColor;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3f animations:^{
                        cell.backgroundColor = [UIColor whiteColor];
                    }];
                }];
            });
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UserRecord *userRecord = anObject;
            cell.textLabel.text = userRecord.userName;
            UserInfo *userInfo = userRecord.userInfo;
            if (userInfo.currentLogin) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - STMeFooterViewDelegate

- (void)footerView:(STMeFooterView *)footerView didClickLoginOutButton:(UIButton *)loginOutButton
{
    id<ILoginMgr> loginMgr = [Hub getLoginMgr];
    [loginMgr loginOutWithUserName:loginMgr.currentLoginUserName completeBlock:^(UserRecord *userRecord, STError *error) {
        if (error) {
            [self presentFailureTips:error.errorTip];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:userRecord.userName forKey:lastUserName];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[LoginViewController alloc] init];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
