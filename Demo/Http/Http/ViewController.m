//
//  ViewController.m
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "ViewController.h"

#import "HttpManager.h"
#import "HttpConst.h"
#import "ReachabilityStatusModel.h"

#import "NetTestViewController.h"

@interface ViewController ()
- (IBAction)click;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange:) name:kNoti_AFNetworkReachabilityStatusUnknown object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange:) name:kNoti_AFNetworkReachabilityStatusNotReachable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange:) name:kNoti_AFNetworkReachabilityStatusReachableViaWWAN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusChange:) name:kNoti_AFNetworkReachabilityStatusReachableViaWiFi object:nil];
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

- (void)netStatusChange:(NSNotification *)noti
{
    ReachabilityStatusModel *statusModel = noti.object;
    
    NSLog(@"name : %@\nbeforeStatus : %ld\ncurrentStatus : %ld", noti.name, (long)statusModel.oldStatus, (long)statusModel.newStatus);
    
    if ([noti.name isEqualToString:kNoti_AFNetworkReachabilityStatusReachableViaWiFi]) {
        
    } else if ([noti.name isEqualToString:kNoti_AFNetworkReachabilityStatusReachableViaWWAN]) {
        
    } else if ([noti.name isEqualToString:kNoti_AFNetworkReachabilityStatusNotReachable]) {
        
    } else { // kNoti_AFNetworkReachabilityStatusUnknown
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)click {
    [self.navigationController pushViewController:[[NetTestViewController alloc] init] animated:YES];
}
@end
