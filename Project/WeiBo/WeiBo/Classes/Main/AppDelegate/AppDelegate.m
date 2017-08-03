//
//  AppDelegate.m
//  WeiBo
//
//  Created by wbs on 17/2/6.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "AppDelegate.h"

#import "WBTabBarController.h"
#import "WBLoginViewController.h"
#import "WBAccountTool.h"
#import "WBAccount.h"

#import "WBNetAPIManager.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置IQKeyboardManager
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.keyboardDistanceFromTextField = 40.0;
    keyboardManager.enableAutoToolbar = NO;
    
    // 延长lunchImage的时间，可以让主线程sleep
    [NSThread sleepForTimeInterval:0.5];
    
    // 设置根控制器
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    WBAccount *accout = [WBAccountTool account];
    if (accout) {
        self.window.rootViewController = [[WBTabBarController alloc] init];
    } else {
        self.window.rootViewController = [[WBLoginViewController alloc] init];
    }
    
    // 开启网络监听
    [WBNetAPIManager startReachabilityStatusMonitor];

    return YES;
}

/** SDWebImage的内存警告处理 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    
    // 取消所有的下载操作
    [sdManager cancelAll];
    
    // 清除内存缓存
    [sdManager.imageCache clearMemory];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
