//
//  STCompanyActionViewController.m
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STCompanyActionViewController.h"

#import "Hub.h"
#import "STCompanyActionMgr.h"
#import "CompanyRecord+CoreDataClass.h"
#import "CompanyInfo+CoreDataClass.h"
#import "STErrorMgr.h"

@interface STCompanyActionViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) NSManagedObjectContext *context;
@property (nonatomic, strong) NSFetchedResultsController<CompanyRecord *> *fetchedResultsController;
@end

@implementation STCompanyActionViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (NSManagedObjectContext *)context
{
    id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
    return companyActionMgr.context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadUI];
    
    [self configFetchedResultsController];
    [self checkData];
}

- (void)loadUI
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCompany)];
    
    // tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)configFetchedResultsController
{
    NSFetchRequest *fetchRequest = [CompanyRecord fetchRequest];
    NSSortDescriptor *sortDescriptor0 = [NSSortDescriptor sortDescriptorWithKey:@"company" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", [Hub getLoginMgr].currentLoginUserName];
    [fetchRequest setPredicate:predicate];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:@"userName" cacheName:nil];
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

#pragma mark - Action

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCompany
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"添加公司" message:@"请填写一个公司的名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请填写一个公司的名称";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *certainA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSArray<UITextField *> *textFields = alertC.textFields;
        if (textFields.count) {
            UITextField *textField = textFields.firstObject;
            if (textField.text.length) {
                id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
                id<ILoginMgr> loginMgr = [Hub getLoginMgr];
                [companyActionMgr addCompany:textField.text userName:loginMgr.currentLoginUserName completeBlock:^(CompanyRecord *userRecord, STError *error) {
                    if (error) {
                        [self presentFailureTips:error.errorTip];
                    } else {
                        
                    }
                }];
            } else {
                [self presentMessageTips:@"公司名称不能为空"];
            }
        } else {
            
        }
    }];
    [alertC addAction:cancelA];
    [alertC addAction:certainA];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)scrollToBottom
{
    if (!self.fetchedResultsController.fetchedObjects.count) return;
    NSIndexPath *lastIndexPath = [self.fetchedResultsController indexPathForObject:self.fetchedResultsController.fetchedObjects.lastObject];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
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
    static NSString *cellID = @"company";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CompanyRecord *companyRecord = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = companyRecord.company;
    if (companyRecord.companyInfo.selected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyRecord *companyRecord = self.fetchedResultsController.fetchedObjects[indexPath.row];
    if (companyRecord.companyInfo.selected) return;
    [[Hub getCompanyActionMgr] selectCompany:companyRecord completeBlock:^(CompanyRecord *userRecord, STError *error) {
        [self back];
    }];
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
                [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
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
            CompanyRecord *companyRecord = anObject;
            cell.textLabel.text = companyRecord.company;
            if (companyRecord.companyInfo.selected) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
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
    [self.tableView endUpdates];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
