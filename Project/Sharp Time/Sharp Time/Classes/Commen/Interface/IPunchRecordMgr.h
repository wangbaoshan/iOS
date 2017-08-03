//
//  IPunchRecordMgr.h
//  Sharp Time
//
//  Created by power on 2017/5/16.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IBaseMgr.h"

@class PunchRecord;
@class STError;

@protocol IPunchRecordMgr <IBaseMgr>

@required
- (PunchRecord *)todayPunchRecordWithUserName:(NSString *)userName companyName:(NSString *)companyName;
- (void)punchRecordNowWithUserName:(NSString *)userName companyName:(NSString *)companyName completeBlock:(void (NS_NOESCAPE^)(PunchRecord *punchRecord, STError *error))complete;

@end
