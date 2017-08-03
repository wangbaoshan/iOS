//
//  WBAccount.h
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBUser;

@interface WBAccount : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSString *expires_in; // access_token的生命周期，单位是秒数
@property (nonatomic, copy) NSDate *expires_time; // 过期时间

@property (nonatomic, strong) WBUser *user;

@end
