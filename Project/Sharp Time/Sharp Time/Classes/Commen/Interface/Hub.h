//
//  Hub.h
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILoginMgr.h"
#import "IErrorMgr.h"
#import "ICompanyActionMgr.h"
#import "IPunchRecordMgr.h"
#import "ISettingMgr.h"

@interface Hub : NSObject

+ (void)initializeManager;

+ (id<ILoginMgr>)getLoginMgr;
+ (id<IErrorMgr>)getErrorMgr;
+ (id<ICompanyActionMgr>)getCompanyActionMgr;
+ (id<IPunchRecordMgr>)getPunchRecordMgr;
+ (id<ISettingMgr>)getSettingMgr;

@end
