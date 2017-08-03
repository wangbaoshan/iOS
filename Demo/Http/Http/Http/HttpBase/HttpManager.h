//
//  HttpManager.h
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//  基础网络请求类

#import "AFHTTPSessionManager.h"

typedef enum : NSUInteger {
    NetMethod_GET = 999,
    NetMethod_POST,
    NetMethod_PUT
} NetMethod;

@interface HttpManager : AFHTTPSessionManager

/// 单例
+ (HttpManager *)shareNetAPIManager;

/** 基础网络请求
 *  @param urlString 请求路径
 *  @param parameters 请求参数
 *  @param method 请求方式
 *  @param timeInterval 请求超时时间，传0默认为20s（kTimeOutInterval宏定义）
 *  @param completion 请求结果
 *  @param code 请求索引码，方便查找，http请求中无意义
 *  @return (NSURLSessionTask *) 指向请求生命周期的可取消对象
 */
+ (NSURLSessionTask *)requestWithURL:(NSString *)urlString
                          parameters:(NSMutableDictionary *)parameters
                              method:(NetMethod)method
                        timeInterval:(NSTimeInterval)timeInterval
                          completion:(void(^)(id responseObjects, NSError *error))completion
                       httpIndexCode:(NSInteger)code;
- (NSURLSessionTask *)requestWithURL:(NSString *)urlString
                          parameters:(NSMutableDictionary *)parameters
                              method:(NetMethod)method
                        timeInterval:(NSTimeInterval)timeInterval
                          completion:(void(^)(id responseObjects, NSError *error))completion
                       httpIndexCode:(NSInteger)code;

/// 开启\结束网络监听
+ (void)startReachabilityStatusMonitor;
+ (void)stopReachabilityStatusMonitor;

/// 使用以下方法获取网络当前时刻的网络状态，必须要提前开启网络监听
+ (BOOL)reachable; // 是否有网络连接
+ (BOOL)reachableViaWWAN; // 是否通过蜂窝数据连接网络
+ (BOOL)reachableViaWiFi; // 是否通过WiFi连接网络

/// 使用以下方法用来准确获取网络当前时刻的网络状态
+ (BOOL)currentReachable; // 是否有网络连接
+ (BOOL)currentReachableViaWWAN; // 是否通过蜂窝数据连接网络
+ (BOOL)currentReachableViaWiFi; // 是否通过WiFi连接网络

@end

