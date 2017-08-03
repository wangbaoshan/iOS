//
//  IBaseMgr.h
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IBaseMgr <NSObject>

@required
@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

@end
