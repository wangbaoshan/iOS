//
//  WBAccountTool.h
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBAccount;
@class WBUser;

@interface WBAccountTool : NSObject

+ (WBAccount *)account;
+ (void)archieveAccount:(WBAccount *)account;

+ (NSString *)access_token;
+ (NSString *)uid;

+ (WBUser *)user;

@end
