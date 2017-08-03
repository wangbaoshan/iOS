//
//  WBAccountTool.m
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBAccountTool.h"

#import "WBAccount.h"

#define kAccountFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation WBAccountTool

+ (WBAccount *)account
{
    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:kAccountFilePath];
    
    NSDate *now = [NSDate date];
    if ([now compare:account.expires_time] != NSOrderedAscending) { // 过期
        account = nil;
    }
    
    return account;
}

+ (void)archieveAccount:(WBAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:kAccountFilePath];
}

+ (NSString *)access_token
{
    return [self account].access_token;
}

+ (NSString *)uid
{
    return [self account].uid;
}

+ (WBUser *)user
{
    return [self account].user;
}

@end
