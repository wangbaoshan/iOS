//
//  ReachabilityStatusModel.h
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface ReachabilityStatusModel : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus oldStatus;
@property (nonatomic, assign) AFNetworkReachabilityStatus newStatus;

+ (__kindof ReachabilityStatusModel *)reachabilityStatusModel;

@end

