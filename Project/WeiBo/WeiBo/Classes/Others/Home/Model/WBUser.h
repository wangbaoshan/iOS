//
//  WBUser.h
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBUser : NSObject

@property (nonatomic, copy) NSString *name; // 友好显示名称
@property (nonatomic, copy) NSString *profile_image_url; // 用户头像地址（中图），50×50像素
@property (nonatomic, copy) NSString *idstr; // 字符串型的用户UID
@property (nonatomic, copy) NSNumber *province; // 用户所在省级ID
@property (nonatomic, copy) NSNumber *city; // 用户所在城市ID
@property (nonatomic, copy) NSString *des; // 用户个人描述
@property (nonatomic, copy) NSString *gender; // 性别，m：男、f：女、n：未知
@property (nonatomic, copy) NSNumber *followers_count; // 粉丝数
@property (nonatomic, copy) NSNumber *friends_count; // 关注数
@property (nonatomic, copy) NSNumber *statuses_count; // 微博数
@property (nonatomic, copy) NSNumber *favourites_count; // 收藏数
@property (nonatomic, copy) NSNumber *bi_followers_count; // 用户的互粉数

@end
