//
//  IErrorMgr.h
//  Sharp Time
//
//  Created by power on 2017/5/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STError;

@protocol IErrorMgr <NSObject>

@required
- (STError *)createError;

@end
