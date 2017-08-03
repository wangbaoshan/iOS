//
//  STHomeViewController.m
//  Sharp Time
//
//  Created by power on 2017/4/20.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STHomeViewController.h"

#import "STRecorderCell.h"
#import "PunchInfo+CoreDataProperties.h"
#import "PunchRecord+CoreDataProperties.h"
#import "CompanyRecord+CoreDataProperties.h"
#import "STTitleButton.h"
#import "STCompanyActionViewController.h"
#import "STNavigationController.h"
#import "Hub.h"
#import "STPunchRecordMgr.h"
#import "STErrorMgr.h"
#import "STCompanyActionMgr.h"

#import "UIBarButtonItem+BS.h"
#import "DIYConst.h"
#import "SystemParameter.h"
#import "UIView+Extension.h"
#import "NSDate+Extension.h"
#import "SVProgressHUD+Tips.h"
#import "NSObject+Tips.h"
#import "Singleton.h"
#import "Colours.h"


@interface STHomeViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) STTitleButton *titleButton;

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController<PunchRecord *> *fetchedResultsController;

@property (nonatomic, assign, getter=isAddObservered) BOOL addObservered;

@end

static NSString *cellID = @"record";
#define kActionViewHeight 180.0f

@implementation STHomeViewController

- (NSManagedObjectContext *)context
{
    id<IPunchRecordMgr> punchRecordMgr = [Hub getPunchRecordMgr];
    return punchRecordMgr.context;
}

static const NSString *currentLoginUserCompanyNameContext;

- (void)dealloc
{
    if (self.isAddObservered) {
        STCompanyActionMgr *companyActionMgr = (STCompanyActionMgr *)[Hub getCompanyActionMgr];
        [companyActionMgr removeObserver:self forKeyPath:@"currentLoginUserCompanyName" context:&currentLoginUserCompanyNameContext];
    }
    
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadUI];
    [self addObserverForCurrentLoginUserCompanyName];
    [self configFetchedResultsController];
    [self checkData];
}

- (void)addObserverForCurrentLoginUserCompanyName
{
    STCompanyActionMgr *companyActionMgr = (STCompanyActionMgr *)[Hub getCompanyActionMgr];
    [companyActionMgr addObserver:self forKeyPath:@"currentLoginUserCompanyName" options:NSKeyValueObservingOptionNew context:&currentLoginUserCompanyNameContext];
    self.addObservered = YES;
}

- (void)loadUI
{
    // Nav
    self.navigationItem.titleView = self.titleButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打卡" style:UIBarButtonItemStylePlain target:self action:@selector(rightAway)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"置底" style:UIBarButtonItemStylePlain target:self action:@selector(scrollToBottom)];
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAddStatusBarHeight, kScreenWidth, kScreenHeight - kTabBarHeight - kNavBarAddStatusBarHeight) style:UITableViewStyleGrouped];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"STRecorderCell" bundle:nil] forCellReuseIdentifier:cellID];
    
    [self renameTitle];
}


- (void)configFetchedResultsController
{
    if ([Hub getCompanyActionMgr].currentLoginUserCompanyName.length == 0) return;
    NSFetchRequest *fetchRequest = [PunchRecord fetchRequest];
    NSSortDescriptor *sortDescriptor0 = [NSSortDescriptor sortDescriptorWithKey:@"punchInfo.recordTime" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ && company = %@", [Hub getLoginMgr].currentLoginUserName, [Hub getCompanyActionMgr].currentLoginUserCompanyName];
    [fetchRequest setPredicate:predicate];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"punchInfo.yearMonthString" cacheName:nil];
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
        [self scrollToBottom];
    }
}

- (void)renameTitle
{
    NSString *title = [Hub getCompanyActionMgr].currentLoginUserCompanyName.length ? [Hub getCompanyActionMgr].currentLoginUserCompanyName : @"点击设置";
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}


- (STTitleButton *)titleButton
{
    if (_titleButton == nil) {
         _titleButton = [STTitleButton titleButtonWithConstHeight:30.0f maxWidth:kScreenWidth sideMargin:5.0f font:[UIFont boldSystemFontOfSize:17]];
        [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_titleButton setBackgroundImage:[UIImage imageNamed:@"timeline_card_top_background_highlighted"] forState:UIControlStateHighlighted];
        [_titleButton addTarget:self action:@selector(companyChoose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

#pragma mark - Action

- (void)companyChoose
{
    STCompanyActionViewController *companyActionVc = [[STCompanyActionViewController alloc] init];
    STNavigationController *companyActionNvc = [[STNavigationController alloc] initWithRootViewController:companyActionVc];
    [self presentViewController:companyActionNvc animated:YES completion:nil];
}

- (void)scrollToBottom
{
    if (!self.fetchedResultsController.fetchedObjects.count) return;
    NSIndexPath *lastIndexPath = [self.fetchedResultsController indexPathForObject:self.fetchedResultsController.fetchedObjects.lastObject];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

- (void)rightAway
{
    id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
    if (!companyActionMgr.currentLoginUserCompanyName.length) {
        [self presentFailureTips:@"请先为记录添加一个公司"];
        return;
    }
    id<IPunchRecordMgr> punchRecordMgr = [Hub getPunchRecordMgr];
    id<ILoginMgr> loginMgr = [Hub getLoginMgr];
    [punchRecordMgr punchRecordNowWithUserName:loginMgr.currentLoginUserName companyName:companyActionMgr.currentLoginUserCompanyName completeBlock:^(PunchRecord *punchRecord, STError *error) {
        if (error) {
            [self presentFailureTips:error.errorTip];
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == &currentLoginUserCompanyNameContext) {
        [self renameTitle];
        [self configFetchedResultsController];
        [self checkData];
    }
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
    STRecorderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    PunchRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.record = record;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.fetchedResultsController.sections.count) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return sectionInfo.name;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PunchRecord *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.context deleteObject:record];
        [self.context save:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // 在这里调用beginUpdates通知tableView开始更新，注意要和endUpdates联用
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
    // beginUpdates之后，这个方法会调用，根据不同类型，来对tableView进行操作，注意什么时候该用indexPath，什么时候用newIndexPath.
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
                STRecorderCell *cell = [self.tableView cellForRowAtIndexPath:newIndexPath];
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
            STRecorderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.record = anObject;
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
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
    // 更新完后会回调这里，调用tableView的endUpdates.
    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
