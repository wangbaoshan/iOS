//
//  XMainMgr.h
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

@interface XMainMgr : NSObject
{
    id<ILoginMgr>         _loginMgr;
    id<IErrorMgr>         _erroeMgr;
    id<ICompanyActionMgr> _companyActionMgr;
    id<IPunchRecordMgr>   _punchRecordMgr;
    id<ISettingMgr>       _settingMgr;
}

- (id<ILoginMgr>)getLoginMgr;
- (id<IErrorMgr>)getErrorMgr;
- (id<ICompanyActionMgr>)getCompanyActionMgr;
- (id<IPunchRecordMgr>)getPunchRecordMgr;
- (id<ISettingMgr>)getSettingMgr;

@end
