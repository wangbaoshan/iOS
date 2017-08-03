//
//  WBAccount.m
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBAccount.h"

@implementation WBAccount

MJCodingImplementation

- (void)setExpires_in:(NSString *)expires_in
{
    _expires_in = expires_in;
    
    // 确定帐号的过期时间
    NSDate *now = [NSDate date];
    self.expires_time = [now dateByAddingTimeInterval:expires_in.doubleValue];
}

@end
