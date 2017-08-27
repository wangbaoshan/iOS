//
//  APIConst.m
//  WeiBo
//
//  Created by wbs on 17/2/9.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "APIConst.h"

NSTimeInterval const kTimeOutInterval = 15.0f;

NSString *const kBaseAPIUrlString = @"https://api.weibo.com";

NSString *const kGetAccessTokenUrlString = @"oauth2/access_token";

NSString *const kCurrentUserWeiBoUrlString = @"2/statuses/home_timeline.json";
NSString *const kPublicWeiBoUrlString = @"2/statuses/public_timeline.json";

NSString *const kCurrentUserContentUrlString = @"2/users/show.json";

NSString *const kMyFunsUrlString = @"2/friendships/followers.json";
