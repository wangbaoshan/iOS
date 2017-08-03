//
//  HttpConst.h
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 网络监听，当网络状态发生改变时会发送通知
FOUNDATION_EXTERN NSString *const kNoti_AFNetworkReachabilityStatusUnknown;
FOUNDATION_EXTERN NSString *const kNoti_AFNetworkReachabilityStatusNotReachable;
FOUNDATION_EXTERN NSString *const kNoti_AFNetworkReachabilityStatusReachableViaWWAN;
FOUNDATION_EXTERN NSString *const kNoti_AFNetworkReachabilityStatusReachableViaWiFi;

FOUNDATION_EXTERN NSTimeInterval const kTimeOutInterval; // 请求超时时间
FOUNDATION_EXTERN NSString *const kBaseAPIUrlString; // baseUrl

