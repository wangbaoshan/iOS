//
//  WBStatus.h
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBUser;
@class WBStatusPhoto;

@interface WBStatus : NSObject

@property (nonatomic, copy) NSString *created_at; // 微博创建时间
@property (nonatomic, copy) NSString *idstr; // 字符串型的微博ID
@property (nonatomic, copy) NSNumber *idNum; // 微博ID
@property (nonatomic, copy) NSString *text; // 微博信息内容
@property (nonatomic, copy) NSString *source; // 微博来源

@property (nonatomic, strong) WBUser *user; // 微博作者的用户信息字段
@property (nonatomic, strong) WBStatus *retweeted_status; // 被转发的原微博信息字段，当该微博为转发微博时返回

@property (nonatomic, copy) NSNumber *reposts_count; // 转发数
@property (nonatomic, copy) NSNumber *comments_count; // 评论数
@property (nonatomic, copy) NSNumber *attitudes_count; // 表态数

@property (nonatomic, strong) NSArray<WBStatusPhoto *> *pic_urls;

/// 微博信息图文混排内容
@property (nonatomic, copy) NSAttributedString *attributeText;

@end
