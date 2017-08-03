//
//  NetTestViewController.m
//  Http
//
//  Created by power on 2017/6/26.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "NetTestViewController.h"

#import "HttpManager.h"
#import "HttpConst.h"
#import "ReachabilityStatusModel.h"


#import "HttpBusiness.h"

#import "FetchBannerlistRequest.h"
#import "FetchBannerlistResponse.h"
#import "BannerResult.h"

#import "HttpManager+Encrpty.h"

@interface NetTestViewController ()

@end

@implementation NetTestViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"请看控制台";
    
    [self logCurrentNetStatus];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"appType"] =  @"1";
    param[@"username"] = @"18733540977";
    param[@"password"] = @"111111";
    [HttpManager encryptRequestWithURL:@"loginWithPwdByApp.do" parameters:param method:NetMethod_POST timeInterval:15.0f completion:^(id responseObjects, NSError *error) {
        NSLog(@"result ===== %@", responseObjects);
    } httpIndexCode:1000];
    
    FetchBannerlistRequest *request = [FetchBannerlistRequest request];
    [HttpBusiness fetchBannerlist:request completion:^(FetchBannerlistResponse *bannerlistResponse, NSError *error) {
        NSLog(@"%@", bannerlistResponse.body.bannerList.lastObject.bannerUrl);
    }];
}

- (void)logCurrentNetStatus
{
    NSLog(@"是否有网络-----%d", [HttpManager currentReachable]);
    NSLog(@"是否是WIFI-----%d", [HttpManager currentReachableViaWiFi]);
    NSLog(@"是否是移动数据-----%d", [HttpManager currentReachableViaWWAN]);
    
    NSLog(@"----------------------------------------------------");
    
    NSLog(@"是否有网络-----%d", [HttpManager reachable]);
    NSLog(@"是否是WIFI-----%d", [HttpManager reachableViaWiFi]);
    NSLog(@"是否是移动数据-----%d", [HttpManager reachableViaWWAN]);
}


@end
