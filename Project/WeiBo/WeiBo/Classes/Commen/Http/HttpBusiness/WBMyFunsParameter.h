//
//  WBMyFunsParameter.h
//  WeiBo
//
//  Created by bao on 2017/8/27.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "WBBaseAPIParameter.h"

@interface WBMyFunsParameter : WBBaseAPIParameter

/// 需要查询的用户UID
@property (nonatomic, copy) NSNumber *uid;
/// 需要查询的用户昵称
@property (nonatomic, copy) NSString *screen_name;
/// 单页返回的记录条数，默认为5，最大不超过5
@property (nonatomic, copy) NSNumber *count;
/// 返回结果的游标，下一页用返回值里的next_cursor，上一页用previous_cursor，默认为0
@property (nonatomic, copy) NSNumber *cursor;
/// 返回值中user字段中的status字段开关，0：返回完整status字段、1：status字段仅返回status_id，默认为1
@property (nonatomic, copy) NSNumber *trim_status;

@end
