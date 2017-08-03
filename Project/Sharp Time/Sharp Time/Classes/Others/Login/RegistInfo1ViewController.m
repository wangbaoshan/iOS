//
//  RegistInfo1ViewController.m
//  Sharp Time
//
//  Created by power on 2017/5/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "RegistInfo1ViewController.h"

#import "RegistInfo2ViewController.h"

#import "Hub.h"
#import "STErrorMgr.h"

@interface RegistInfo1ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UITextField *certainPasswordFiled;

@end

@implementation RegistInfo1ViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"注册账户";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(next)];
}

- (void)next
{
    if (![self checkForFiled]) {
        return;
    }
    
    id<ILoginMgr> loginMgr = [Hub getLoginMgr];
    [loginMgr registWithUserName:self.userNameFiled.text password:self.passwordFiled.text completeBlock:^(UserRecord *userRecord, STError *error) {
        if (userRecord) {
            if ([self.delegate respondsToSelector:@selector(registInfo1ViewController:didFinishRegistUser:)]) {
                [self.delegate registInfo1ViewController:self didFinishRegistUser:self.userNameFiled.text];
            }
            RegistInfo2ViewController *registVc = [[RegistInfo2ViewController alloc] init];
            registVc.registUserName = [self.userNameFiled.text copy];
            [self.navigationController pushViewController:registVc animated:YES];
        } else {
            [self presentFailureTips:error.errorTip];
        }
    }];
}

- (BOOL)checkForFiled
{
    if (self.userNameFiled.text.length == 0) {
        [self presentMessageTips:@"请输入账号"];
        return NO;
    }
    if (self.passwordFiled.text.length == 0) {
        [self presentMessageTips:@"请输入密码"];
        return NO;
    }
    if (self.certainPasswordFiled.text.length == 0) {
        [self presentMessageTips:@"请输入确认密码"];
        return NO;
    }
    
    if (![self.passwordFiled.text isEqualToString:self.certainPasswordFiled.text]) {
        self.certainPasswordFiled.text = nil;
        [self presentMessageTips:@"确认密码和密码不一致，请重新输入"];
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
