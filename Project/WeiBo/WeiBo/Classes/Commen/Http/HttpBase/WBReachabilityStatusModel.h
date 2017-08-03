//
//  WBReachabilityStatusModel.h
//  WeiBo
//
//  Created by wbs on 17/2/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface WBReachabilityStatusModel : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus oldStatus;

+ (__kindof WBReachabilityStatusModel *)reachabilityStatusModel;

@end
