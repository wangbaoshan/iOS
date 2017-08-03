//
//  WBMeItem.h
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    WBMeItemTypeArrow,
    WBMeItemTypePoint,
    WBMeItemTypeSwitch,
    WBMeItemTypeNone
} WBMeItemType;

@interface WBMeItem : NSObject

@property (nonatomic, assign) WBMeItemType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imageString;

+ (__kindof WBMeItem *)item;

@end
