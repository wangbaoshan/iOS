//
//  WBCacheTool.m
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBCacheTool.h"

#import "NSString+WBExtension.h"

@implementation WBCacheTool

+ (void)sizeWithCachePath:(NSString *)cachePath andCaculateSDImageCache:(BOOL)sdCache owner:(__weak id)owner complete:(void(^)(NSString *sizeString))complete
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        unsigned long long size = cachePath.fileSize;
        if (sdCache) {
            size += [SDImageCache sharedImageCache].getSize;
        }
        
        if (owner == nil) return;
        
        NSString *sizeText = nil;
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        NSString *text = [NSString stringWithFormat:@"%@", sizeText];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(text);
        });
        
    });
}

+ (void)clearCachePath:(NSString *)cachePath andClearSDImageCache:(BOOL)sdCache complete:(void(^)(NSError *error))complete
{
    BOOL existCachePath = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    
    if (existCachePath) {
        
        if (sdCache) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                // 删除自定义的缓存
                __block NSError *error = nil;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
                });
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(error);
                });
            }];
        } else {
            __block NSError *error = nil;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [[NSFileManager defaultManager] removeItemAtPath:cachePath error:&error];
            });
            
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(error);
            });
        }
        
    } else {
        
        if (sdCache) {
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(nil);
                });
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil);
            });
        }
    }
}

@end
