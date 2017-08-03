//
//  WBNetAPIManager.h
//  WeiBo
//
//  Created by wbs on 17/2/9.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "AFNetworking.h"

typedef enum : NSUInteger {
    WBNetMethod_GET = 999,
    WBNetMethod_POST,
    WBNetMethod_PUT
} WBNetMethod;

@interface WBNetAPIManager : AFHTTPSessionManager

+ (NSURLSessionTask *)requestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(WBNetMethod)method completion:(void(^)(id responseObjects, NSError *error))completion; // 基础网络请求

+ (void)startReachabilityStatusMonitor; // 开启网络监听
+ (void)stopReachabilityStatusMonitor; // 结束网络监听

+ (BOOL)reachable; // 是否有网络连接
+ (BOOL)reachableViaWWAN; // 是否通过蜂窝数据连接网络
+ (BOOL)reachableViaWiFi; // 是否通过WiFi连接网络

@end
