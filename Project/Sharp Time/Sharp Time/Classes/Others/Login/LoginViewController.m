//
//  LoginViewController.m
//  Sharp Time
//
//  Created by power on 2017/5/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "LoginViewController.h"

#import "STNavigationController.h"
#import "STTabBarController.h"
#import "RegistInfo1ViewController.h"
#import "STSymbolView.h"
#import "Hub.h"
#import "STErrorMgr.h"
#import "UserRecord+CoreDataClass.h"
#import "UserInfo+CoreDataClass.h"

NSString *const lastUserName = @"lastUserName";

@interface LoginViewController () <RegistInfo1ViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwordFiled;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet STSymbolView *symbolView;

- (IBAction)regist;
- (IBAction)login;
@end

@implementation LoginViewController

- (void)dealloc
{
    STLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self symbolViewStartAnimation];
    
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:kSystemNavigationItemHighlightColor forState:UIControlStateSelected];
    [self.registButton setTitleColor:kSystemNavigationItemNormalColor forState:UIControlStateNormal];
    [self.registButton setTitleColor:kSystemNavigationItemHighlightColor forState:UIControlStateSelected];
    
    self.loginButton.backgroundColor = kSystemNavigationItemNormalColor;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.loginButton.layer.cornerRadius = 5;
    
    if (!self.userName.length) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:lastUserName];
        self.userName = userName;
    } else {
        self.userName = self.userName;
    }
    
}

- (void)setUserName:(NSString *)userName
{
    _userName = [userName copy];
    
    self.userNameFiled.text = userName;
}

- (void)symbolViewStartAnimation
{
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.repeatCount = MAXFLOAT;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 5.0f;
    UIBezierPath *path=[UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.symbolView.frame, self.symbolView.frame.size.width / 2 - 5, self.symbolView.frame.size.height / 2 - 5)];
    pathAnimation.path=path.CGPath;
    [self.symbolView.layer addAnimation:pathAnimation forKey:nil];
    
    CAKeyframeAnimation *scaleX=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.values = @[@1.0, @1.07, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5,@1.0];
    scaleX.repeatCount = MAXFLOAT;
    scaleX.autoreverses = YES;
    scaleX.removedOnCompletion = NO;
    scaleX.duration = 5.0f;
    [self.symbolView.layer addAnimation:scaleX forKey:nil];
    
    CAKeyframeAnimation *scaleY=[CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.values = @[@1.0, @1.07, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5,@1.0];
    scaleY.repeatCount = MAXFLOAT;
    scaleY.autoreverses = YES;
    scaleY.removedOnCompletion = NO;
    scaleY.duration = 5.0f;
    [self.symbolView.layer addAnimation:scaleY forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)createExistRegistButton
{
    UIButton *existButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = kSystemNavigationItemNormalColor;
        [button setTitle:@"已经有账号了" forState:UIControlStateNormal];
        [button setTitle:@"已经有账号了" forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:kSystemNavigationItemHighlightColor forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(exitRegist) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    return existButton;
}

- (void)exitRegist
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)regist {
    
    RegistInfo1ViewController *registVc = [[RegistInfo1ViewController alloc] init];
    registVc.delegate = self;
    STNavigationController *registNav = [[STNavigationController alloc] initWithRootViewController:registVc];
    [registNav.view addSubview:[self createExistRegistButton]];
    [self presentViewController:registNav animated:YES completion:nil];
    
}

- (IBAction)login {
    
    if (![self checkForFiled]) {
        return;
    }
    
    id<ILoginMgr> loginMgr = [Hub getLoginMgr];
    [loginMgr changeLoginAccountWithUserName:self.userNameFiled.text password:self.passwordFiled.text completeBlock:^(UserRecord *userRecord, STError *error) {
        if (userRecord) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[STTabBarController alloc] init];
        } else {
            [self presentMessageTips:error.errorTip];
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
    
    return YES;
}

#pragma mark - RegistInfo1ViewControllerDelegate

- (void)registInfo1ViewController:(RegistInfo1ViewController *)registInfo1ViewController didFinishRegistUser:(NSString *)userName
{
    self.userName = userName;
}
@end
