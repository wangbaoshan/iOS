//
//  HttpBaseResponse.h
//  Http
//
//  Created by power on 2017/4/14.
//  Copyright © 2017年 powertorque. All rights reserved.
//  请求响应的基础类，根据每个公司后台返回的数据而定

#import <Foundation/Foundation.h>

@interface HttpBaseResponse : NSObject

@property (nonatomic, copy) NSString *requestStatus; // 成功:success  错误：error 异常：exception
@property (nonatomic, copy) NSString *returCode; // PR0000代表成功，ER1111代表失败，ER9999为未登录，其他值待定
@property (nonatomic, copy) NSString *returnTip; // 错误提示

@end
