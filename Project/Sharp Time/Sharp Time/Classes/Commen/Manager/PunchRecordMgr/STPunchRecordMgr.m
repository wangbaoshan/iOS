//
//  STPunchRecordMgr.m
//  Sharp Time
//
//  Created by power on 2017/5/16.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STPunchRecordMgr.h"

#import "PunchRecord+CoreDataClass.h"
#import "PunchInfo+CoreDataClass.h"
#import "Hub.h"
#import "STErrorMgr.h"

@implementation STPunchRecordMgr

- (PunchRecord *)todayPunchRecordWithUserName:(NSString *)userName companyName:(NSString *)companyName
{
    NSFetchRequest *fetchRequest = [PunchRecord fetchRequest];
    
    NSString *currentYearMonthString = [NSString stringWithFormat:@"%ld年%02ld月", [NSDate currentYear], [NSDate currentMonth]];
    NSString *currentDayString = [NSString stringWithFormat:@"%02ld日", [NSDate currentDay]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ && company = %@ && punchInfo.yearMonthString = %@ && punchInfo.dayString = %@",userName, companyName, currentYearMonthString, currentDayString];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray<PunchRecord *> *fetchResults = [self.context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
    } else {
        STLog(@"fetch success");
    }
    if (fetchResults.count) {
        return fetchResults.firstObject;
    } else {
        return nil;
    }
}

- (void)punchRecordNowWithUserName:(NSString *)userName companyName:(NSString *)companyName completeBlock:(void (^)(PunchRecord *, STError *))complete
{
    PunchRecord *punchRecord = [self todayPunchRecordWithUserName:userName companyName:companyName];
    if (punchRecord) { // 修改操作
        if ([NSDate isTodayMorning]) { // 是今天上午
            if (punchRecord.punchInfo.morningRecord) {
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"已经记录过了";
                complete(nil, tError);
            } else {
                PunchInfo *punchInfo = punchRecord.punchInfo;
                punchRecord.punchInfo = nil;
                punchInfo.morningRecord = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", [NSDate currentHour], [NSDate currentMinute], [NSDate currentSecond]];
                punchRecord.punchInfo = punchInfo;
                NSError *error = nil;
                [self.context save:&error];
                if (error) {
                    STLog(@"save failure : %@", error.localizedDescription);
                    STError *tError = [[Hub getErrorMgr] createError];
                    tError.errorTip = @"数据库修改失败";
                    tError.errorDetail = error;
                    complete(nil, tError);
                } else {
                    complete(punchRecord, nil);
                }
            }
        } else { // 是今天下午
            if (punchRecord.punchInfo.afternoonRecord) {
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"已经记录过了";
                complete(nil, tError);
            } else {
                PunchInfo *punchInfo = punchRecord.punchInfo;
                punchRecord.punchInfo = nil;
                punchInfo.afternoonRecord = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", [NSDate currentHour], [NSDate currentMinute], [NSDate currentSecond]];
                punchRecord.punchInfo = punchInfo;
                NSError *error = nil;
                [self.context save:&error];
                if (error) {
                    STLog(@"save failure : %@", error.localizedDescription);
                    STError *tError = [[Hub getErrorMgr] createError];
                    tError.errorTip = @"数据库修改失败";
                    tError.errorDetail = error;
                    complete(nil, tError);
                } else {
                    complete(punchRecord, nil);
                }
            }
        }
    } else { // 插入操做
        PunchRecord *record = [NSEntityDescription insertNewObjectForEntityForName:@"PunchRecord" inManagedObjectContext:self.context];
        record.userName = userName;
        record.company = companyName;
        PunchInfo *punchInfo = [[PunchInfo alloc] initWithContext:self.context];
        punchInfo.dayString = [NSString stringWithFormat:@"%02ld日", [NSDate currentDay]];
        punchInfo.yearMonthString = [NSString stringWithFormat:@"%ld年%02ld月", [NSDate currentYear], [NSDate currentMonth]];
        punchInfo.recordTime = [[NSDate date] timeIntervalSince1970];
        if ([NSDate isTodayMorning]) { // 是今天上午
            punchInfo.morningRecord = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", [NSDate currentHour], [NSDate currentMinute], [NSDate currentSecond]];
        } else { // 是今天下午
            punchInfo.afternoonRecord = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", [NSDate currentHour], [NSDate currentMinute], [NSDate currentSecond]];
        }
        record.punchInfo = punchInfo;
        
        NSError *error = nil;
        [self.context save:&error];
        if (error) {
            STLog(@"insert failure : %@", error.localizedDescription);
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"数据库插入失败";
            tError.errorDetail = error;
            complete(nil, tError);
        } else {
            complete(record, nil);
        }
    }
}

@end
