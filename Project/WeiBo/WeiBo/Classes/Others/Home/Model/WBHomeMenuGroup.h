//
//  WBHomeMenuGroup.h
//  WeiBo
//
//  Created by wbs on 17/3/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBHomeMenuItem;

@interface WBHomeMenuGroup : NSObject

@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, copy) NSArray<WBHomeMenuItem *> *items;

@end
