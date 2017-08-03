//
//  PlayerVIewController.m
//  Player
//
//  Created by wbs on 17/1/3.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "PlayerVIewController.h"

#import "BSPlayer.h"

@interface PlayerVIewController () <BSPlayerDelegate>

@property (nonatomic, weak) BSPlayer *player;
@property (nonatomic, weak) UILabel *label;

@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;

@end

@implementation PlayerVIewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    BSPlayer *player = [[BSPlayer alloc] init];
    player.frame = CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9 / 16);
    player.backgroundColor = [UIColor blackColor];
    [player replaceItemWithUrl:[NSURL URLWithString:@"http://hc.yinyuetai.com/uploads/videos/common/B65B013CF61E82DC9766E8BDEEC8B602.flv?sc=8cafc5714c8a6265"]];
    player.containerController = self;
    player.delegate = self;
    [self.view addSubview:player];
    self.player = player;
    
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.text = @"打酱油的";
    label.frame = CGRectMake(0, CGRectGetMaxY(self.player.frame), self.player.frame.size.width, 200);
    label.backgroundColor = [UIColor greenColor];
    [self.view addSubview:label];
    self.label = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
}

- (void)pop
{
    [self.player tryToPause]; // 删除页面要调用此方法，以便播放器迅速销毁
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCurrentOrientation:(UIInterfaceOrientation)currentOrientation
{
    _currentOrientation = currentOrientation;
    
    if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight) {
        self.navigationController.navigationBar.hidden = YES;
    } else {
        self.navigationController.navigationBar.hidden = NO;
    }
    
    [self.navigationController setNeedsStatusBarAppearanceUpdate]; // 如果你的控制器是push出来的，要在导航控制器改变导航栏状态
    [self setNeedsStatusBarAppearanceUpdate]; // 如果你的控制器是model出来的，要在当前控制器改变导航栏状态
    
}

#pragma mark - XMLPlayerDelegate

- (void)player:(BSPlayer *)player deviceOrientationDidChange:(UIInterfaceOrientation)orientation
{
    self.label.frame = CGRectMake(0, CGRectGetMaxY(self.player.frame), self.player.frame.size.width, 200);
    
    self.currentOrientation = orientation;
}


- (BOOL)shouldAutorotate
{
    return NO;
}

// 设置状态栏是否隐藏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == UIInterfaceOrientationLandscapeLeft || currentOrientation == UIInterfaceOrientationLandscapeRight) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
