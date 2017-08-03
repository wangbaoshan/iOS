//
//  XMainMgr.m
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "XMainMgr.h"

#import "STLoginMgr.h"
#import "STErrorMgr.h"
#import "STCompanyActionMgr.h"
#import "STPunchRecordMgr.h"
#import "STSettingMgr.h"

@implementation XMainMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getLoginMgr];
    }
    return self;
}

- (id<ILoginMgr>)getLoginMgr
{
    if (_loginMgr == nil) {
        _loginMgr = [[STLoginMgr alloc] init];
    }
    return _loginMgr;
}

- (id<IErrorMgr>)getErrorMgr
{
    if (_erroeMgr == nil) {
        _erroeMgr = [[STErrorMgr alloc] init];
    }
    return _erroeMgr;
}

- (id<ICompanyActionMgr>)getCompanyActionMgr
{
    if (_companyActionMgr == nil) {
        _companyActionMgr = [[STCompanyActionMgr alloc] init];
    }
    return _companyActionMgr;
}

- (id<IPunchRecordMgr>)getPunchRecordMgr
{
    if (_punchRecordMgr == nil) {
        _punchRecordMgr = [[STPunchRecordMgr alloc] init];
    }
    return _punchRecordMgr;
}

- (id<ISettingMgr>)getSettingMgr
{
    if (_settingMgr == nil) {
        _settingMgr = [[STSettingMgr alloc] init];
    }
    return _settingMgr;
}

@end
