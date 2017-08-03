//
//  HttpManager+Upload.h
//  Http
//
//  Created by power on 2017/7/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//  文件上传

#import "HttpManager.h"

@interface HttpManager (Upload)

/** 上传单张图片
 *  @param urlString 请求路径
 *  @param data 上传的图片data
 *  @param parameters 请求参数
 *  @param completion 请求结果
 *  @param code 请求索引码，方便查找，http请求中无意义
 *  @return (NSURLSessionTask *) 指向请求生命周期的可取消对象
 */
+ (NSURLSessionTask *)uploadImageRequestWithURL:(NSString *)urlString
                                      imageData:(NSData *)data
                                     parameters:(NSMutableDictionary *)parameters
                                     completion:(void (^)(id, NSError *))completion
                                  httpIndexCode:(NSInteger)code;
- (NSURLSessionTask *)uploadImageRequestWithURL:(NSString *)urlString
                                      imageData:(NSData *)data
                                     parameters:(NSMutableDictionary *)parameters
                                     completion:(void (^)(id, NSError *))completion
                                  httpIndexCode:(NSInteger)code;

/** 上传单个视频
 *  @param urlString 请求路径
 *  @param data 上传的视频data
 *  @param parameters 请求参数
 *  @param completion 请求结果
 *  @param code 请求索引码，方便查找，http请求中无意义
 *  @return (NSURLSessionTask *) 指向请求生命周期的可取消对象
 */
+ (NSURLSessionTask *)uploadVideoRequestWithURL:(NSString *)urlString
                                      imageData:(NSData *)data
                                     parameters:(NSMutableDictionary *)parameters
                                     completion:(void (^)(id, NSError *))completion
                                  httpIndexCode:(NSInteger)code;
- (NSURLSessionTask *)uploadVideoRequestWithURL:(NSString *)urlString
                                      imageData:(NSData *)data
                                     parameters:(NSMutableDictionary *)parameters
                                     completion:(void (^)(id, NSError *))completion
                                  httpIndexCode:(NSInteger)code;

@end
