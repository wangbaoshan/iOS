//
//  HttpManager+Upload.m
//  Http
//
//  Created by power on 2017/7/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "HttpManager+Upload.h"

#import "HttpConst.h"

@implementation HttpManager (Upload)

+ (NSURLSessionTask *)uploadImageRequestWithURL:(NSString *)urlString imageData:(NSData *)data parameters:(NSMutableDictionary *)parameters completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    return [[self shareNetAPIManager] uploadImageRequestWithURL:urlString imageData:data parameters:parameters completion:completion httpIndexCode:code];
}

- (NSURLSessionTask *)uploadImageRequestWithURL:(NSString *)urlString imageData:(NSData *)data parameters:(NSMutableDictionary *)parameters completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIUrlString]];
    // 接收类型不一致请替换
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    return [mgr POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        // 上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/png"];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        // 上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        // 上传成功
        completion(responseObject, nil);
        [mgr invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        // 上传失败
        completion(nil, error);
        [mgr invalidateSessionCancelingTasks:YES];
    }];
}


+ (NSURLSessionTask *)uploadVideoRequestWithURL:(NSString *)urlString imageData:(NSData *)data parameters:(NSMutableDictionary *)parameters completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    return [[self shareNetAPIManager] uploadVideoRequestWithURL:urlString imageData:data parameters:parameters completion:completion httpIndexCode:code];
}

- (NSURLSessionTask *)uploadVideoRequestWithURL:(NSString *)urlString imageData:(NSData *)data parameters:(NSMutableDictionary *)parameters completion:(void (^)(id, NSError *))completion httpIndexCode:(NSInteger)code
{
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseAPIUrlString]];
    // 接收类型不一致请替换
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    return [mgr POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
        // 上传的参数(上传视频，以文件流的格式)
        [formData appendPartWithFileData:data
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"video/quicktime"];
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        // 上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        // 上传成功
        completion(responseObject, nil);
        [mgr invalidateSessionCancelingTasks:YES];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        // 上传失败
        completion(nil, error);
        [mgr invalidateSessionCancelingTasks:YES];
    }];
}


@end
