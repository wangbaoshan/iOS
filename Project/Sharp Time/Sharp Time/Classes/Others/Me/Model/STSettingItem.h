//
//  STSettingItem.h
//  Sharp Time
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    STSettingItemTypeArrow = 0,
    STSettingItemTypeNone,
    STSettingItemTypeSwitch,
    STSettingItemTypeTextField
} STSettingItemType;

@interface STSettingItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) STSettingItemType type;

@end
