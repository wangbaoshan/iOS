//
//  Hub.m
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "Hub.h"

#import "XMainMgr.h"

static XMainMgr *_xmainMgr = nil;

@implementation Hub

+ (void)initializeManager
{
    if (_xmainMgr == nil) {
        _xmainMgr = [[XMainMgr alloc] init];
    }
}

+ (id<ILoginMgr>)getLoginMgr
{
    return [_xmainMgr getLoginMgr];
}

+ (id<IErrorMgr>)getErrorMgr
{
    return [_xmainMgr getErrorMgr];
}

+ (id<ICompanyActionMgr>)getCompanyActionMgr
{
    return [_xmainMgr getCompanyActionMgr];
}

+ (id<IPunchRecordMgr>)getPunchRecordMgr
{
    return [_xmainMgr getPunchRecordMgr];
}

+ (id<ISettingMgr>)getSettingMgr
{
    return [_xmainMgr getSettingMgr];
}

@end
