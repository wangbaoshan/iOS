//
//  WBHomeStatusesResult.h
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBStatus;

@interface WBHomeStatusesResult : NSObject

@property (nonatomic, strong) NSArray<WBStatus *> *statuses;

@end
