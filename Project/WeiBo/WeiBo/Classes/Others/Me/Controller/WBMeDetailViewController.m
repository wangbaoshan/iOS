//
//  WBMeDetailViewController.m
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBMeDetailViewController.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBUser.h"

static CGFloat const kHeaderViewHeight = 170.0f;
static CGFloat const kChangStatusY = 80.0f;

@interface WBMeDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *bgImageView;
//@property (nonatomic, strong) UIButton *returnBtn;
//@property (nonatomic, strong) UIButton *searchBtn;
//@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, assign) CGFloat pullDownScale;

@end

@implementation WBMeDetailViewController

- (void)dealloc
{
    kWBLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // UI
    [self loadUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView.contentOffset.y) {
        [self scrollViewDidScroll:self.tableView];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] alpha:1.0] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithImageStr:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kSystemNavigationBarLineColor alpha:1.0]];
}


- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [WBAccountTool account].user.name;
    UIBarButtonItem *rightBarButtonItemSearch = [UIBarButtonItem itemWithImageName:@"userinfo_tabicon_search" highlightImageName:@"userinfo_tabicon_search_highlighted" target:self action:@selector(search)];
    UIBarButtonItem *rightBarButtonItemMore = [UIBarButtonItem itemWithImageName:@"userinfo_tabicon_more" highlightImageName:@"userinfo_tabicon_more_highlighted" target:self action:@selector(more)];
    self.navigationItem.rightBarButtonItems = @[rightBarButtonItemMore, rightBarButtonItemSearch];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kNavBarAddStatusBarHeight, kScreenWidth, kScreenWidth)];
    bgImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profile_cover_background@2x" ofType:@"jpg"]];
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAddStatusBarHeight, kScreenWidth, kScreenHeight - kNavBarAddStatusBarHeight) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeaderViewHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
    
    self.pullDownScale = (kScreenHeight - kScreenWidth + kNavBarAddStatusBarHeight) / (kScreenHeight - kNavBarAddStatusBarHeight - kHeaderViewHeight);
}

- (void)search
{
    
}
- (void)more
{
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 28;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"meDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    view.backgroundColor = [UIColor lightGrayColor];
    return view;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = self.tableView.contentOffset.y;
//    NSLog(@"%f", y);
    
    if (y <= 0) {
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(kHeaderViewHeight - y, 0, 0, 0);
        self.bgImageView.transform = CGAffineTransformMakeTranslation(0, - y * self.pullDownScale);
    } else {
        self.bgImageView.transform = CGAffineTransformMakeTranslation(0, -y);
        
        CGFloat alpha = 0.0;
        if (y >= kChangStatusY && y <= kHeaderViewHeight) {
            alpha = (y - kChangStatusY) / (kHeaderViewHeight - kChangStatusY);
            UIImage *image = [UIImage imageWithColor:kSystemNavigationBarBackgroundColor alpha:alpha];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            image = [UIImage imageWithColor:kSystemNavigationBarLineColor alpha:alpha];
            [self.navigationController.navigationBar setShadowImage:image];
            
            if (alpha == 0.0) {
                
            } else if (alpha == 1.0) {
                
            } else {
                
            }
        } else if (y > kHeaderViewHeight) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage resizedImageWithImageStr:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kSystemNavigationBarLineColor alpha:1.0]];
        } else {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] alpha:1.0] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        }
    }
    
}

- (UIButton *)buttonWithName:(NSString *)name image:(NSString *)imageName highlight:(NSString *)highlightName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [[UIButton alloc] init];
    CGSize textSize;
    if (name) {
        textSize = [name sizeWithAttributes:@{NSFontAttributeName : kSystemNavigationItemFont}];
        [button setTitle:name forState:UIControlStateNormal];
    }
    button.frame = (CGRect){{0, 0}, {image.size.width + textSize.width, image.size.height}};
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightName] forState:UIControlStateHighlighted];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
