//
//  WBHomeStatusesParamter.h
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBBaseAPIParameter.h"

@interface WBHomeStatusesParamter : WBBaseAPIParameter

@property (nonatomic, copy) NSNumber *count; // 单页返回的记录条数，默认为50
@property (nonatomic, copy) NSNumber *page; // 返回结果的页码，默认为1
@property (nonatomic, copy) NSNumber *base_app; // 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0
@property (nonatomic, copy) NSNumber *max_id; // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0
@property (nonatomic, copy) NSNumber *since_id; // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
@property (nonatomic, copy) NSNumber *feature; // 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0



@end
