//
//  WBMyFuns.h
//  WeiBo
//
//  Created by bao on 2017/8/27.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBMyFun;

@interface WBMyFuns : NSObject

@property (nonatomic, strong) NSArray<WBMyFun *> *users;

@end

@interface WBMyFun : NSObject

/// 友好显示名称
@property (nonatomic, copy) NSString *name;
/// 用户头像地址（中图），50×50像素
@property (nonatomic, copy) NSString *profile_image_url;

@end
