//
//  WBMeGroup.h
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBMeItem;

@interface WBMeGroup : NSObject

@property (nonatomic, copy) NSString *headerString;
@property (nonatomic, copy) NSString *footerString;

@property (nonatomic, copy) NSArray<WBMeItem *> *items;

+ (__kindof WBMeGroup *)group;

@end
