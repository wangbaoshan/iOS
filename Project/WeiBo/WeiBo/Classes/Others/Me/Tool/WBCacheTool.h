//
//  WBCacheTool.h
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBCacheTool : NSObject

+ (void)sizeWithCachePath:(NSString *)cachePath andCaculateSDImageCache:(BOOL)sdCache owner:(__weak id)owner complete:(void(^)(NSString *sizeString))complete; // 计算缓存大小，结果以字符串的格式返回

+ (void)clearCachePath:(NSString *)cachePath andClearSDImageCache:(BOOL)sdCache complete:(void(^)(NSError *error))complete; // 清除缓存

@end
