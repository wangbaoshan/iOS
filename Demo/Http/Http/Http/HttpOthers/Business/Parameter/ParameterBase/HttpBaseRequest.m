//
//  HttpBaseRequest.m
//  Http
//
//  Created by power on 2017/4/14.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "HttpBaseRequest.h"

@implementation HttpBaseRequest

+ (HttpBaseRequest *)request
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
