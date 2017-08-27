//
//  WBTabBarController.m
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBTabBarController.h"

#import "WBNavigationController.h"
#import "WBHomeViewController.h"
#import "WBMessageViewController.h"
#import "WBDiscoverViewController.h"
#import "WBMeViewController.h"
#import "WBSendViewController.h"

#import "WBTabBar.h"

@interface WBTabBarController () <WBTabBarDelegate>

@end

@implementation WBTabBarController

+ (void)initialize
{
    [super initialize];
    [self setupTabBarTheme];
    [self setupTabBarItemTheme];
}

/** 设置UITabBar的样式 */
+ (void)setupTabBarTheme
{
    UITabBar *tabBar = [UITabBar appearance];
    // 设置TabBar color
    [tabBar setBarTintColor:kCSSHexColor(@"#F2D8D5")];
}

/** 设置UITabBarItem的样式 */
+ (void)setupTabBarItemTheme
{
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    // normal
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kSystemTabBarItemNormalColor;
    textAttrs[NSFontAttributeName] = kSystemTabBarTitleFont;
    [tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // selected
    NSMutableDictionary *seletedTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    seletedTextAttrs[NSForegroundColorAttributeName] = kSystemTabBarItemSelectedColor;
    [tabBarItem setTitleTextAttributes:seletedTextAttrs forState:UIControlStateSelected];
}


#pragma mark - WBTabBarDelegate

- (void)tabBar:(WBTabBar *)tabBar didClickPlusButton:(UIButton *)plusButton
{
    WBSendViewController *sendVC = [[WBSendViewController alloc] init];
    WBNavigationController *sendNav = [[WBNavigationController alloc] initWithRootViewController:sendVC];
    [self presentViewController:sendNav animated:YES completion:nil];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBaseViewControllerBackgroundColor;
    
    [self addSubChildControllers];
    
    WBTabBar *tabBarNew = [[WBTabBar alloc] init];
    tabBarNew.delegate = self;
    [self setValue:tabBarNew forKey:@"tabBar"];
    
//    self.selectedIndex = 3;
}

/** 添加子控制器 */
- (void)addSubChildControllers
{
    [self addOneChlildVc:[[WBHomeViewController alloc] init] title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    [self addOneChlildVc:[[WBMessageViewController alloc] init] title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    [self addOneChlildVc:[[WBDiscoverViewController alloc] init] title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    [self addOneChlildVc:[[WBMeViewController alloc]init] title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
}


/** 添加子控制器方法 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    UIImage *selectedImg = [UIImage imageNamed:selectedImageName];
    if (kIS_IOS7) { // iOS7不渲染，显示原来图片
        selectedImg = [selectedImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImg;
    
    // XMLNavigationController为自定义导航控制器
    WBNavigationController *navVC = [[WBNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navVC];
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
