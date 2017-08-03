//
//  ILoginMgr.h
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IBaseMgr.h"

@class UserRecord;
@class UserInfo;
@class STError;

@protocol ILoginMgr <IBaseMgr>

@required
@property (nonatomic, copy, readonly) NSString *currentLoginUserName;

- (void)autoLogin:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete;

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completeBlock:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete;
- (void)loginOutWithUserName:(NSString *)userName completeBlock:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete;

- (void)changeLoginAccountWithUserName:(NSString *)userName password:(NSString *)password completeBlock:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete;

- (void)registWithUserName:(NSString *)userName password:(NSString *)password completeBlock:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete;

#pragma mark - User

- (UserInfo *)userInfoWithUserName:(NSString *)userName;
- (void)editMyIconWithUserName:(NSString *)userName image:(UIImage *)image completeBlock:(void (NS_NOESCAPE^)(UIImage *image, STError *error))complete;


@end
