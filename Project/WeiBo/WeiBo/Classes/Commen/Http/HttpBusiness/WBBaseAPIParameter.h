//
//  WBBaseAPIParameter.h
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBBaseAPIParameter : NSObject

@property (nonatomic, copy) NSString *access_token; // 采用OAuth授权方式为必填参数，OAuth授权后获得

+ (__kindof WBBaseAPIParameter *)param;

@end
