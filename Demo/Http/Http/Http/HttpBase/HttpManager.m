//
//  HttpManager.m
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "HttpManager.h"

#import "HttpConst.h"
#import "HttpLoger.h"
#import "ReachabilityStatusModel.h"
#import "Reachability.h"

static HttpManager *_netAPIManager = nil;

@implementation HttpManager

+ (HttpManager *)shareNetAPIManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netAPIManager = [[HttpManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIUrlString]];
        _netAPIManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _netAPIManager.responseSerializer.acceptableContentTypes = [_netAPIManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        _netAPIManager.requestSerializer.timeoutInterval = kTimeOutInterval;
    });
    
    return _netAPIManager;
}

+ (NSURLSessionTask *)requestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(NetMethod)method timeInterval:(NSTimeInterval)timeInterval completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    return [[self shareNetAPIManager] requestWithURL:urlString parameters:parameters method:method timeInterval:timeInterval completion:completion httpIndexCode:code];
}

- (NSURLSessionTask *)requestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(NetMethod)method timeInterval:(NSTimeInterval)timeInterval completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    NSURLSessionTask *sessionTask = nil;
    
    
    _netAPIManager.requestSerializer.timeoutInterval = (timeInterval > 0) ? timeInterval : kTimeOutInterval;
    
#ifdef DEBUG
    [HttpLoger logDebugInfoWithApiName:urlString requestParams:parameters httpMethod:method];
#endif
    
    switch (method) {
        case NetMethod_GET:
        {
            sessionTask = [self GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
#ifdef DEBUG
                // 打印数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:jsonString request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    completion(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(nil, error);
                }
                
            }];
        }
            break;
            
        case NetMethod_POST:
        {
            sessionTask = [self POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
#ifdef DEBUG
                // 打印数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:jsonString request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    completion(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(nil, error);
                }
                
            }];
        }
            break;
            
        case NetMethod_PUT:
        {
            [self PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
#ifdef DEBUG
                // 打印数据
                NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:jsonString request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    completion(responseObject, nil);
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(nil, error);
                }
                
            }];
        }
            break;
            
        default:
            break;
    }
    return sessionTask;
}


static AFNetworkReachabilityStatus _beforeReachabilityStatus = -2; // 初始为-2

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
                ReachabilityStatusModel *statusModel = [ReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                statusModel.newStatus = AFNetworkReachabilityStatusUnknown;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusUnknown object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusUnknown;
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络
            {
                ReachabilityStatusModel *statusModel = [ReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                statusModel.newStatus = AFNetworkReachabilityStatusNotReachable;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusNotReachable object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusNotReachable;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 3G/4G
            {
                ReachabilityStatusModel *statusModel = [ReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                statusModel.newStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                [[NSNotificationCenter defaultCenter] postNotificationName:kNoti_AFNetworkReachabilityStatusReachableViaWWAN object:statusModel];
                _beforeReachabilityStatus = AFNetworkReachabilityStatusReachableViaWWAN;
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
            {
                ReachabilityStatusModel *statusModel = [ReachabilityStatusModel reachabilityStatusModel];
                statusModel.oldStatus = _beforeReachabilityStatus;
                statusModel.newStatus = AFNetworkReachabilityStatusReachableViaWiFi;
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

+ (BOOL)currentReachable
{
    Reachability *rech = [Reachability reachabilityForInternetConnection];
    return !(rech.currentReachabilityStatus == NotReachable);
}

+ (BOOL)currentReachableViaWWAN
{
    Reachability *rech = [Reachability reachabilityForInternetConnection];
    return (rech.currentReachabilityStatus == ReachableViaWWAN);
}

+ (BOOL)currentReachableViaWiFi
{
    Reachability *rech = [Reachability reachabilityForInternetConnection];
    return (rech.currentReachabilityStatus == ReachableViaWiFi);
}

@end
