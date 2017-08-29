//
//  WBNetAPIManager.m
//  WeiBo
//
//  Created by wbs on 17/2/9.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBNetAPIManager.h"

#import "WBNetAPILoger.h"
#import "WBReachabilityStatusModel.h"

@implementation WBNetAPIManager

static WBNetAPIManager *_netAPIManager = nil;

+ (WBNetAPIManager *)shareNetAPIManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netAPIManager = [[WBNetAPIManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIUrlString]];
        _netAPIManager.responseSerializer.acceptableContentTypes = [_netAPIManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _netAPIManager.requestSerializer.timeoutInterval = kTimeOutInterval;

    });
    return _netAPIManager;
}

+ (NSURLSessionTask *)requestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(WBNetMethod)method completion:(void (^)(id, NSError *))completion
{
    return [[self shareNetAPIManager] requestWithURL:urlString parameters:parameters method:method completion:completion];
}

- (NSURLSessionTask *)requestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(WBNetMethod)method completion:(void (^)(id, NSError *))completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionTask *sessionTask = nil;
    
#ifdef DEBUG
    [WBNetAPILoger logDebugInfoWithApiName:urlString requestParams:parameters httpMethod:method];
#endif
    
    switch (method) {
        case WBNetMethod_GET:
        {
            sessionTask = [self GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
#ifdef DEBUG
                // 打印数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [WBNetAPILoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:jsonString request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    completion(responseObject, nil);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [WBNetAPILoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(@"error", error);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            }];
        }
            break;
            
        case WBNetMethod_POST:
        {
            sessionTask = [self POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
#ifdef DEBUG
                // 打印数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [WBNetAPILoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:jsonString request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    completion(responseObject, nil);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [WBNetAPILoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(@"error", error);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }];
        }
            break;
            
        case WBNetMethod_PUT:
        {
            [self PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
#ifdef DEBUG
                // 打印数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [WBNetAPILoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:jsonString request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    completion(responseObject, nil);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [WBNetAPILoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(@"error", error);
                }
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            }];
        }
            break;
            
        default:
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
            break;
    }
    return sessionTask;
}


static AFNetworkReachabilityStatus _beforeReachabilityStatus = -2;

+ (void)startReachabilityStatusMonitor
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    [statusManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /**
         AFNetworkReachabilityStatusUnknown          = -1,
         AFNetworkReachabilityStatusNotReachable     = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知
            {
                WBReachabilityStatusModel *statusModel = [WBReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusUnknown object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusUnknown;
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络
            {
                WBReachabilityStatusModel *statusModel = [WBReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusNotReachable object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusNotReachable;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 3G/4G
            {
                WBReachabilityStatusModel *statusModel = [WBReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusReachableViaWWAN object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusReachableViaWWAN;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
            {
                WBReachabilityStatusModel *statusModel = [WBReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusReachableViaWiFi object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusReachableViaWiFi;
            }
                break;
                
            default:
                break;
        }
    }];
    [statusManager startMonitoring];
}

+ (void)stopReachabilityStatusMonitor
{
    AFNetworkReachabilityManager *statusManager = [AFNetworkReachabilityManager sharedManager];
    [statusManager stopMonitoring];
    _beforeReachabilityStatus = -2;
}

+ (BOOL)reachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)reachableViaWWAN
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)reachableViaWiFi
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

@end
