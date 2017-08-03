//
//  WBLoginViewController.m
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBLoginViewController.h"

#import "WBTabBarController.h"
#import "OAuth.h"
#import "WBAccount.h"
#import "WBAccountTool.h"
#import "WBNetAPIManager.h"

@interface WBLoginViewController () <UIWebViewDelegate>

@end

@implementation WBLoginViewController

- (void)dealloc
{
    kWBLogMothodFunc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *authorStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", kClient_id, kRedirect_uri];
    NSURL *authorUrl = [NSURL URLWithString:authorStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:authorUrl];
    
    // 添加webView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    NSRange rang = [urlStr rangeOfString:@"code="];
    if (rang.length != 0) {
        NSMutableString *code = [NSMutableString string];
        for (NSInteger i = rang.location + rang.length; i < urlStr.length; i++) {
            char c = [urlStr characterAtIndex:i];
            if (c == '&') {
                break;
            } else {
                [code appendString:[NSString stringWithFormat:@"%c", c]];
            }
        }
        [self getAccessTokenWithCode:code];
    }
    return YES;
}

- (void)getAccessTokenWithCode:(NSString *)code
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = kClient_id;
    params[@"client_secret"] = kClient_secret;
    params[@"grant_type"] = kGrant_type;
    params[@"code"] = code;
    params[@"redirect_uri"] = kRedirect_uri;
    
    [WBNetAPIManager requestWithURL:kGetAccessTokenUrlString parameters:params method:WBNetMethod_POST completion:^(id responseObjects, NSError *error) {
        if (error) {
            
        } else {
            [UIApplication sharedApplication].keyWindow.rootViewController = [[WBTabBarController alloc] init];
            WBAccount *account = [WBAccount mj_objectWithKeyValues:responseObjects];
            [WBAccountTool archieveAccount:account];
        }
        
    }];
    
    
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
