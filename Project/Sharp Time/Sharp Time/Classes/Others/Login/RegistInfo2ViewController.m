//
//  RegistInfo2ViewController.m
//  Sharp Time
//
//  Created by power on 2017/5/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "RegistInfo2ViewController.h"

#import "Hub.h"
#import "STCompanyActionMgr.h"
#import "STErrorMgr.h"


@interface RegistInfo2ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *companyFiled;

@end

@implementation RegistInfo2ViewController

- (void)dealloc
{
    STLogMothodFunc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"添加一个公司";
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
}

- (void)next
{
    if (![self checkForFiled]) {
        return;
    }
    
    id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
    [companyActionMgr addCompany:self.companyFiled.text userName:self.registUserName completeBlock:^(CompanyRecord *userRecord, STError *error) {
        if (error) {
            [self presentFailureTips:error.errorTip];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (BOOL)checkForFiled
{
    if (!self.companyFiled.text.length) {
        [self presentMessageTips:@"请输入一个公司的名称"];
        return NO;
    }
    return YES;
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
