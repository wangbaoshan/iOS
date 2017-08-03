//
//  WBPublicStatusesParamter.h
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBBaseAPIParameter.h"

@interface WBPublicStatusesParamter : WBBaseAPIParameter

@property (nonatomic, copy) NSNumber *count; // 单页返回的记录条数，默认为50
@property (nonatomic, copy) NSNumber *page; // 返回结果的页码，默认为1
@property (nonatomic, copy) NSNumber *base_app; // 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0

@end
