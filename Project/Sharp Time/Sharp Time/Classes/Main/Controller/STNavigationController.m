//
//  STNavigationController.m
//  Sharp Time
//
//  Created by power on 2017/4/20.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STNavigationController.h"

@interface STNavigationController ()

@end

@implementation STNavigationController

//- (UIViewController *)childViewControllerForStatusBarStyle
//{
//    return self.viewControllers.lastObject;
//}

+ (void)initialize
{
    [super initialize];
    
    [self setupNavigationBarTheme];
    [self setupBarButtonItemTheme];
    
}

+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.tintColor = [UIColor redColor];
    
//    [appearance setBackgroundImage:[UIImage imageNamed:@"navBar"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = kSystemNavigationTitleFont;  // UITextAttributeFont --> NSFontAttributeName(iOS7)
    [appearance setTitleTextAttributes:textAttrs];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // normal
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kSystemNavigationItemNormalColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // highlight
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = kSystemNavigationItemHighlightColor;
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // disable
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
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
