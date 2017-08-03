//
//  STTabBarController.m
//  Sharp Time
//
//  Created by power on 2017/4/20.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STTabBarController.h"

#import "STNavigationController.h"
#import "STHomeViewController.h"
#import "STMeViewController.h"

@interface STTabBarController ()

@end

@implementation STTabBarController

+ (void)initialize
{
    [super initialize];
    
    [self setupTabBarItemTheme];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubChildControllers];
    
    self.selectedIndex = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)setupTabBarItemTheme
{
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    // normal
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorFromHexString:@"#999999"];
    [tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // selected
    NSMutableDictionary *seletedTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    seletedTextAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [tabBarItem setTitleTextAttributes:seletedTextAttrs forState:UIControlStateSelected];
}


- (void)addSubChildControllers
{
    [self addOneChlildVc:[[STHomeViewController alloc] init] title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    [self addOneChlildVc:[[STMeViewController alloc]init] title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    
    UIImage *selectedImg = [UIImage imageNamed:selectedImageName];
    selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImg;
    
    STNavigationController *navVC = [[STNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navVC];
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
