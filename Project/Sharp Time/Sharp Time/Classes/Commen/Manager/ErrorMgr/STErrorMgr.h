//
//  STErrorMgr.h
//  Sharp Time
//
//  Created by power on 2017/5/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IErrorMgr.h"

@interface STErrorMgr : NSObject <IErrorMgr>

@end


@interface STError : NSObject

@property (nonatomic, copy) NSString *errorTip;
@property (nonatomic, strong) NSError *errorDetail;

@end
