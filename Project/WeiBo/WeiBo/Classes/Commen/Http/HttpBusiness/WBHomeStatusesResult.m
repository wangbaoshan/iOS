//
//  WBHomeStatusesResult.m
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBHomeStatusesResult.h"

@implementation WBHomeStatusesResult

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"statuses" : @"WBStatus"
             };
}

@end
