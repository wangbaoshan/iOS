//
//  APIConst.h
//  WeiBo
//
//  Created by wbs on 17/2/9.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 请求超时时间
FOUNDATION_EXTERN NSTimeInterval const kTimeOutInterval;

/// baseUrl
FOUNDATION_EXTERN NSString *const kBaseAPIUrlString;

// 2.0授权后获取accessToken
FOUNDATION_EXTERN NSString *const kGetAccessTokenUrlString;

/// 获取当前登录用户及其所关注用户的最新微博
FOUNDATION_EXTERN NSString *const kCurrentUserWeiBoUrlString;
/// 获取最新的公共微博
FOUNDATION_EXTERN NSString *const kPublicWeiBoUrlString;
// 获取当前用户的个人信息
FOUNDATION_EXTERN NSString *const kCurrentUserContentUrlString;
/// 获取用户粉丝列表
FOUNDATION_EXTERN NSString *const kMyFunsUrlString;


