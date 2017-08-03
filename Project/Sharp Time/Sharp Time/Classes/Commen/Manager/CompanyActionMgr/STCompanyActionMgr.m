//
//  STCompanyActionMgr.m
//  Sharp Time
//
//  Created by power on 2017/5/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STCompanyActionMgr.h"

#import "CompanyRecord+CoreDataClass.h"
#import "CompanyInfo+CoreDataClass.h"
#import "Hub.h"
#import "STErrorMgr.h"

@interface STCompanyActionMgr ()
{
    NSString *_currentLoginUserCompanyName;
}

@end

@implementation STCompanyActionMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setCurrentLoginUserCompanyName:(NSString *)currentLoginUserCompanyName
{
    _currentLoginUserCompanyName = [currentLoginUserCompanyName copy];
}

- (NSString *)currentLoginUserCompanyName
{
    return _currentLoginUserCompanyName;
}

- (void)updateCurrentLoginUserCompanyName
{
    self.currentLoginUserCompanyName = [self selectedCompanyNameWithUserName:[Hub getLoginMgr].currentLoginUserName];
}

- (NSString *)selectedCompanyNameWithUserName:(NSString *)userName
{
    return [self selectedCompanyWithUserName:userName].company;
}

- (CompanyRecord *)selectedCompanyWithUserName:(NSString *)userName
{
    if (!userName.length) return nil;
    NSFetchRequest *companyRequest = [CompanyRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ && companyInfo.selected = YES", userName];
    [companyRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<CompanyRecord *> *companyRecords = [self.context executeFetchRequest:companyRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        return nil;
    }
    return companyRecords.firstObject;
}

- (void)addCompany:(NSString *)companyName userName:(NSString *)userName completeBlock:(void (^)(CompanyRecord *, STError *))complete
{
    NSFetchRequest *companyRequest = [CompanyRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ && company = %@", userName, companyName];
    [companyRequest setPredicate:predicate];
    NSError *error0 = nil;
    NSArray<CompanyRecord *> *companyRecords = [self.context executeFetchRequest:companyRequest error:&error0];
    if (error0) {
        STLog(@"fetch failure : %@", error0.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询公司失败";
        tError.errorDetail = error0;
        complete(nil, tError);
    } else {
        if (companyRecords.count) {
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"此公司已存在";
            complete(nil, tError);
        } else {
            
            CompanyRecord *comp = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyRecord" inManagedObjectContext:self.context];
            comp.userName = userName;
            comp.company = companyName;
            CompanyInfo *companyInfo = [[CompanyInfo alloc] initWithContext:self.context];
            companyInfo.companyName = companyName;
            comp.companyInfo = companyInfo;
            
            NSError *error1 = nil;
            [self.context save:&error1];
            if (error1) {
                STLog(@"insert failure : %@", error1.localizedDescription);
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"数据库插入公司失败";
                tError.errorDetail = error1;
                complete(nil, tError);
            } else {
                complete(comp, nil);
            }
        }
    }
}

- (void)selectCompany:(NSString *)companyName userName:(NSString *)userName completeBlock:(void (^)(CompanyRecord *, STError *))complete
{
    NSFetchRequest *companyR = [CompanyRecord fetchRequest];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userName = %@ && companyInfo.selected = YES", userName];
    [companyR setPredicate:pred];
    NSError *error0 = nil;
    NSArray<CompanyRecord *> *compRecords = [self.context executeFetchRequest:companyR error:&error0];
    if (error0) {
        STLog(@"fetch failure : %@", error0.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询选中公司失败";
        tError.errorDetail = error0;
        complete(nil, tError);
    } else {
        if (compRecords.count) {
            CompanyRecord *record = compRecords.firstObject;
            CompanyInfo *info = record.companyInfo;
            record.companyInfo = nil;
            info.selected = NO;
            record.companyInfo = info;
        }
        
        NSFetchRequest *company = [CompanyRecord fetchRequest];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@ && company = %@", userName, companyName];
        [company setPredicate:predicate];
        NSError *error1 = nil;
        NSArray<CompanyRecord *> *companyRecords = [self.context executeFetchRequest:company error:&error1];
        if (error1) {
            STLog(@"fetch failure : %@", error0.localizedDescription);
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"数据库查询选中公司失败";
            tError.errorDetail = error0;
            complete(nil, tError);
        } else {
            if (companyRecords.count) {
                CompanyRecord *companyRecord = companyRecords.firstObject;
                CompanyInfo *info = companyRecord.companyInfo;
                companyRecord.companyInfo = nil;
                info.selected = YES;
                companyRecord.companyInfo = info;
                NSError *error2 = nil;
                [self.context save:&error2];
                if (error2) {
                    STLog(@"update failure : %@", error2.localizedDescription);
                    STError *tError = [[Hub getErrorMgr] createError];
                    tError.errorTip = @"数据库修改选中公司失败";
                    tError.errorDetail = error2;
                    complete(nil, tError);
                } else {
                    self.currentLoginUserCompanyName = companyName;
                    complete(companyRecord, nil);
                }
            } else {
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"此公司不存在";
                complete(nil, tError);
            }
        }
    }
}

- (void)selectCompany:(CompanyRecord *)company completeBlock:(void (^)(CompanyRecord *, STError *))complete
{
    NSFetchRequest *companyR = [CompanyRecord fetchRequest];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userName = %@ && companyInfo.selected = YES", company.userName];
    [companyR setPredicate:pred];
    NSError *error0 = nil;
    NSArray<CompanyRecord *> *compRecords = [self.context executeFetchRequest:companyR error:&error0];
    if (error0) {
        STLog(@"fetch failure : %@", error0.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询选中公司失败";
        tError.errorDetail = error0;
        complete(nil, tError);
    } else {
        if (compRecords.count) {
            CompanyRecord *record = compRecords.firstObject;
            CompanyInfo *info = record.companyInfo;
            record.companyInfo = nil;
            info.selected = NO;
            record.companyInfo = info;
        }
        
        CompanyInfo *info = company.companyInfo;
        company.companyInfo = nil;
        info.selected = YES;
        company.companyInfo = info;
        NSError *error1 = nil;
        [self.context save:&error1];
        if (error1) {
            STLog(@"update failure : %@", error1.localizedDescription);
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"数据库修改选中公司失败";
            tError.errorDetail = error1;
            complete(nil, tError);
        } else {
            self.currentLoginUserCompanyName = company.company;
            complete(company, nil);
        }
    }
}

@end
