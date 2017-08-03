//
//  WBBaseAPIParameter.m
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBBaseAPIParameter.h"

#import "WBAccountTool.h"

@implementation WBBaseAPIParameter

+ (WBBaseAPIParameter *)param
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        _access_token = [WBAccountTool access_token];
    }
    return self;
}

@end
