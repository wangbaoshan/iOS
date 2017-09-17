//
//  WBStatus.m
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatus.h"

#import "NSDate+YTT.h"

@implementation WBStatus

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"pic_urls" : @"WBStatusPhoto"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"idNum" : @"id"
             };
}

- (NSString *)created_at
{
    // 1.获得微博的发送时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 真机调试下, 必须加上这段
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createdDate = [fmt dateFromString:_created_at];
    
    // 2.判断微博发送时间 和 现在时间 的差距
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            return [NSString stringWithFormat:@"%ld小时前", (long)createdDate.deltaWithNow.hour];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) { // 昨天
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else { // 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}

- (void)setSource:(NSString *)source
{
    NSInteger loc = [source rangeOfString:@">"].location + 1;
    NSInteger length = [source rangeOfString:@"</"].location - loc;
    source = [source substringWithRange:NSMakeRange(loc, length)];
    _source = [NSString stringWithFormat:@"来自%@", source];
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    
}




@end
