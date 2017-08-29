//
//  NSDate+YTT.h
//  WeiBo
//
//  Created by bao on 2017/8/29.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YTT)

/// 是否为今天
- (BOOL)isToday;

/// 是否为昨天
- (BOOL)isYesterday;

/// 是否为今年
- (BOOL)isThisYear;

/// 返回一个只有年月日的时间
- (NSDate *)dateWithYMD;

/// 获得与当前时间的差距
- (NSDateComponents *)deltaWithNow;

@end
