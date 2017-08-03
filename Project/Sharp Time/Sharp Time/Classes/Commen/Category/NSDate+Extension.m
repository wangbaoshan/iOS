//
//  NSDate+Extension.m
//  Sharp Time
//
//  Created by power on 2017/5/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

+ (NSInteger)currentYear
{
    return [self currentTimeWith:NSCalendarUnitYear].year;
}
+ (NSInteger)currentMonth
{
    return [self currentTimeWith:NSCalendarUnitMonth].month;
}
+ (NSInteger)currentDay
{
    return [self currentTimeWith:NSCalendarUnitDay].day;
}
+ (NSInteger)currentHour
{
    return [self currentTimeWith:NSCalendarUnitHour].hour;
}
+ (NSInteger)currentMinute
{
    return [self currentTimeWith:NSCalendarUnitMinute].minute;
}
+ (NSInteger)currentSecond
{
    return [self currentTimeWith:NSCalendarUnitSecond].second;
}

+ (NSString *)currentTimeString
{
    NSString *format = @"%ld:%02ld:%02ld %02ld:%02ld:%02ld";
    return [NSString stringWithFormat:format, [NSDate currentYear], [NSDate currentMonth], [NSDate currentDay], [NSDate currentHour], [NSDate currentMinute], [NSDate currentSecond]];
}

+ (BOOL)isTodayMorning
{
    return [self currentHour] < 12;
}

+ (BOOL)isTodayAfternoon
{
    return ![self isTodayMorning];
}

+ (NSDateComponents *)currentTimeWith:(NSCalendarUnit)calendarUnit
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = calendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return dateComponent;
}
@end
