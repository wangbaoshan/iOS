//
//  WBUser.m
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBUser.h"

@implementation WBUser

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"des" : @"description"
             };
}

@end
