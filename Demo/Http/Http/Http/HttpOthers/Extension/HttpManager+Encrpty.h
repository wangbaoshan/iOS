//
//  HttpManager+Encrpty.h
//  Http
//
//  Created by power on 2017/4/13.
//  Copyright © 2017年 powertorque. All rights reserved.
//  登录、支付等加密操作

#import "HttpManager.h"

@interface HttpManager (Encrpty)

/** 加密（AES）网络请求
 *  @param urlString 请求路径
 *  @param parameters 请求参数
 *  @param method 请求方式
 *  @param timeInterval 请求超时时间，传0默认为20s（kTimeOutInterval宏定义）
 *  @param completion 请求结果
 *  @param code 请求索引码，方便查找，http请求中无意义
 *  @return (NSURLSessionTask *) 指向请求生命周期的可取消对象
 */
+ (NSURLSessionTask *)encryptRequestWithURL:(NSString *)urlString
                                      parameters:(NSMutableDictionary *)parameters
                                          method:(NetMethod)method
                                    timeInterval:(NSTimeInterval)timeInterval
                                      completion:(void(^)(id responseObjects, NSError *error))completion
                              httpIndexCode:(NSInteger)code;;
- (NSURLSessionTask *)encryptRequestWithURL:(NSString *)urlString
                                      parameters:(NSMutableDictionary *)parameters
                                          method:(NetMethod)method
                                    timeInterval:(NSTimeInterval)timeInterval
                                      completion:(void(^)(id responseObjects, NSError *error))completion
                              httpIndexCode:(NSInteger)code;;

@end
