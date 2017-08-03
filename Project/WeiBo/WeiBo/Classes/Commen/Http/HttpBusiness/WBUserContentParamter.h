//
//  WBUserContentParamter.h
//  WeiBo
//
//  Created by wbs on 17/2/28.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBBaseAPIParameter.h"

@interface WBUserContentParamter : WBBaseAPIParameter

@property (nonatomic, copy) NSString *uid; // 需要查询的用户ID
@property (nonatomic, copy) NSString *screen_name; // 需要查询的用户昵称

@end
