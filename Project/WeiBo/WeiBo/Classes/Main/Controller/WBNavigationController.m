//
//  WBNavigationController.m
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBNavigationController.h"

#import "WBReturnDefaultButton.h"

@interface WBNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer;

@end

@implementation WBNavigationController

+ (void)initialize
{
    [super initialize];
    // 设置UINavigationBarTheme的主题
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

+ (void)setupNavigationBarTheme {
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.translucent = YES; // 默认为YES
    // 设置导航栏
    [appearance setBackgroundImage:[UIImage resizedImageWithImageStr:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[UIImage imageWithColor:kSystemNavigationBarLineColor alpha:1.0]]; // 导航栏下边的线
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kSystemNavigationTitleColor;
    textAttrs[NSFontAttributeName] = kSystemNavigationTitleFont;  // UITextAttributeFont --> NSFontAttributeName(iOS7)
    [appearance setTitleTextAttributes:textAttrs];
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    // normal
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kSystemNavigationItemNormalColor;
    textAttrs[NSFontAttributeName] = kSystemNavigationItemFont;
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // highlight
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = kSystemNavigationItemHighlightColor;
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // disable
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = kSystemNavigationItemDisableColor;
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

#pragma mark - Setter

- (void)setScreenEdgePanGestureRecognizerEnable:(BOOL)screenEdgePanGestureRecognizerEnable
{
    _screenEdgePanGestureRecognizerEnable = screenEdgePanGestureRecognizerEnable;
    self.screenEdgePanGestureRecognizer.enabled = _screenEdgePanGestureRecognizerEnable;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    id target = self.interactivePopGestureRecognizer.delegate;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wundeclared-selector"
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
#pragma clang diagnostic pop
    screenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
    screenEdgePanGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:screenEdgePanGestureRecognizer];
    self.screenEdgePanGestureRecognizer = screenEdgePanGestureRecognizer;
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航栏返回按钮样式
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[WBReturnDefaultButton returnDefaultButtonWithTarget:self title:nil action:@selector(back)]];
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if (self.childViewControllers.count == 1) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
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
