//
//  ICompanyActionMgr.h
//  Sharp Time
//
//  Created by power on 2017/5/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IBaseMgr.h"

@class CompanyRecord;
@class STError;

@protocol ICompanyActionMgr <IBaseMgr>

@required
@property (nonatomic, copy, readonly) NSString *currentLoginUserCompanyName;

- (void)updateCurrentLoginUserCompanyName;
- (NSString *)selectedCompanyNameWithUserName:(NSString *)userName;
- (CompanyRecord *)selectedCompanyWithUserName:(NSString *)userName;

- (void)addCompany:(NSString *)companyName userName:(NSString *)userName completeBlock:(void (NS_NOESCAPE^)(CompanyRecord *userRecord, STError *error))complete;

- (void)selectCompany:(NSString *)companyName userName:(NSString *)userName completeBlock:(void (NS_NOESCAPE^)(CompanyRecord *userRecord, STError *error))complete;
- (void)selectCompany:(CompanyRecord *)company completeBlock:(void (NS_NOESCAPE^)(CompanyRecord *userRecord, STError *error))complete;

@end
