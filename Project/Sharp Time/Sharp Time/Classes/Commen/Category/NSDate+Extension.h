//
//  NSDate+Extension.h
//  Sharp Time
//
//  Created by power on 2017/5/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+ (NSInteger)currentYear; // 当前时间的年
+ (NSInteger)currentMonth; // 当前时间的月
+ (NSInteger)currentDay; // 当前时间的日
+ (NSInteger)currentHour; // 当前时间的时
+ (NSInteger)currentMinute; // 当前时间的分
+ (NSInteger)currentSecond; // 当前时间的秒

+ (NSString *)currentTimeString; // 当前时间串 xxxx:xx:xx xx:xx:xx，24小时制

+ (BOOL)isTodayMorning; // 是不是今天上午
+ (BOOL)isTodayAfternoon; // 是不是今天下午


@end
