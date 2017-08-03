//
//  HttpManager+Encrpty.m
//  Http
//
//  Created by power on 2017/4/13.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "HttpManager+Encrpty.h"

#import "HttpLoger.h"
#import "HttpConst.h"
#import "Base64Encryption.h"
#import "NSString+AES.h"

#define AESKey @"7503408fa9ce487886db0abad39efa5e"

@implementation HttpManager (Encrpty)

+ (NSURLSessionTask *)encryptRequestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(NetMethod)method timeInterval:(NSTimeInterval)timeInterval completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code;
{
    return [[self shareNetAPIManager] encryptRequestWithURL:urlString parameters:parameters method:method timeInterval:timeInterval completion:completion httpIndexCode:code];
}

- (NSURLSessionTask *)encryptRequestWithURL:(NSString *)urlString parameters:(NSMutableDictionary *)parameters method:(NetMethod)method timeInterval:(NSTimeInterval)timeInterval completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    NSURLSessionTask *sessionTask = nil;
    
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIUrlString]];
    mgr.requestSerializer.timeoutInterval = (timeInterval > 0) ? timeInterval : kTimeOutInterval;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
#ifdef DEBUG
    [HttpLoger logDebugInfoWithApiName:urlString requestParams:parameters httpMethod:method];
#endif
    
    // 对parameters做加密处理
    parameters = [Base64Encryption EncryptionDic:parameters key:parameters.allKeys encryptionStr:AESKey];
    
    switch (method) {
        case NetMethod_GET:
        {
            sessionTask = [mgr GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                dataStr = [dataStr AES256DecryptWithKey:AESKey];
                NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
                // 打印数据
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:dataStr request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                    completion(dic, nil);
                }
                
                [mgr invalidateSessionCancelingTasks:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(nil, error);
                }
                
                [mgr invalidateSessionCancelingTasks:YES];
                
            }];
        }
            break;
            
        case NetMethod_POST:
        {
            sessionTask = [mgr POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                dataStr = [dataStr AES256DecryptWithKey:AESKey];
                NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
                // 打印数据
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:dataStr request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                    completion(dic, nil);
                }
                
                [mgr invalidateSessionCancelingTasks:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 NSLog(@"error:%@", error);
#ifdef DEBUG
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(nil, error);
                }
                
                [mgr invalidateSessionCancelingTasks:YES];
                
            }];
        }
            break;
            
        case NetMethod_PUT:
        {
            sessionTask = [mgr PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                dataStr = [dataStr AES256DecryptWithKey:AESKey];
                NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
#ifdef DEBUG
                // 打印数据
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:dataStr request:task.currentRequest error:nil];
#endif
                
                if (completion) {
                    id dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
                    completion(dic, nil);
                }
                
                [mgr invalidateSessionCancelingTasks:YES];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
#ifdef DEBUG
                [HttpLoger logDebugInfoWithResponse:(NSHTTPURLResponse *)task.response resposeString:nil request:task.currentRequest error:error];
#endif
                
                if (completion) {
                    completion(nil, error);
                }
                
                [mgr invalidateSessionCancelingTasks:YES];
                
            }];
        }
            break;
            
        default:
            break;
    }
    return sessionTask;
}


@end
