//
//  WBStatus.m
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatus.h"

@implementation WBStatus

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"pic_urls" : @"WBStatusPhoto"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idNum" : @"id"
             };
}

@end
