//
//  STSettingGroup.h
//  Sharp Time
//
//  Created by power on 2017/6/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STSettingItem;

@interface STSettingGroup : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;

@property (nonatomic, strong) NSArray<STSettingItem *> *items;

@end
