//
//  STLoginMgr.m
//  Sharp Time
//
//  Created by power on 2017/5/11.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STLoginMgr.h"

#import "Hub.h"
#import "STErrorMgr.h"

#import "UserRecord+CoreDataClass.h"
#import "UserInfo+CoreDataClass.h"

@interface STLoginMgr ()
{
    NSString *_currentLoginUserName;
}

@end

@implementation STLoginMgr

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setCurrentLoginUserName:(NSString *)currentLoginUserName
{
    _currentLoginUserName = [currentLoginUserName copy];
}

- (NSString *)currentLoginUserName
{
    return _currentLoginUserName;
}

- (void)autoLogin:(void (^)(UserRecord *, STError *))complete
{
    NSFetchRequest *userRequest = [UserRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userInfo.currentLogin = YES"];
    [userRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<UserRecord *> *userRecords = [self.context executeFetchRequest:userRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询失败";
        tError.errorDetail = error;
        complete(nil, tError);
    } else {
        if (userRecords.count) {
            UserRecord *userRecord = userRecords.firstObject;
            self.currentLoginUserName = userRecord.userName;
            id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
            [companyActionMgr updateCurrentLoginUserCompanyName];
            complete(userRecord, nil);
        } else {
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"无法自动登录";
            complete(nil, tError);
        }
    }
}

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completeBlock:(void (^)(UserRecord *, STError *))complete
{
    NSFetchRequest *userRequest = [UserRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    [userRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<UserRecord *> *userRecords = [self.context executeFetchRequest:userRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询失败";
        tError.errorDetail = error;
        complete(nil, tError);
    } else {
        if (userRecords.count) {
            UserRecord *userRecord = userRecords.firstObject;
            if ([userRecord.userInfo.userPassword isEqualToString:password]) {
                UserInfo *userInfo = userRecord.userInfo;
                userRecord.userInfo = nil;
                userInfo.currentLogin = YES;
                userRecord.userInfo = userInfo;
                NSError *error = nil;
                [self.context save:&error];
                if (error) {
                    STLog(@"insert failure : %@", error.localizedDescription);
                    STError *tError = [[Hub getErrorMgr] createError];
                    tError.errorTip = @"登录状态写入失败";
                    tError.errorDetail = error;
                    complete(nil, tError);
                } else {
                    self.currentLoginUserName = userRecord.userName;
                    id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
                    [companyActionMgr updateCurrentLoginUserCompanyName];
                    complete(userRecord, nil);
                }
                
            } else {
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"密码错误";
                complete(nil, tError);
            }
        } else {
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"此账号不存在";
            complete(nil, tError);
        }
    }
}

- (void)loginOutWithUserName:(NSString *)userName completeBlock:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete
{
    NSFetchRequest *userRequest = [UserRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    [userRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<UserRecord *> *userRecords = [self.context executeFetchRequest:userRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询失败";
        tError.errorDetail = error;
        complete(nil, tError);
    } else {
        if (!userRecords.count) {
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"未知错误，此账号不存在";
            complete(nil, tError);
        } else {
            UserRecord *userRecord = userRecords.firstObject;
            UserInfo *userInfo = userRecord.userInfo;
            userRecord.userInfo = nil;
            userInfo.currentLogin = NO;
            userRecord.userInfo = userInfo;
            NSError *error = nil;
            [self.context save:&error];
            if (error) {
                STLog(@"insert failure : %@", error.localizedDescription);
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"登录状态写入失败";
                tError.errorDetail = error;
                complete(nil, tError);
            } else {
                self.currentLoginUserName = nil;
                id<ICompanyActionMgr> companyActionMgr = [Hub getCompanyActionMgr];
                [companyActionMgr updateCurrentLoginUserCompanyName];
                complete(userRecord, nil);
            }
        }
    }
}

- (void)changeLoginAccountWithUserName:(NSString *)userName password:(NSString *)password completeBlock:(void (^)(UserRecord *, STError *))complete
{
    if (self.currentLoginUserName.length) {
        [self loginOutWithUserName:self.currentLoginUserName completeBlock:^(UserRecord *userRecord, STError *error) {
            if (userRecord) {
                [self loginWithUserName:userName password:password completeBlock:complete];
            } else {
                complete(nil, error);
            }
        }];
    } else {
        [self loginWithUserName:userName password:password completeBlock:complete];
    }
}

- (void)registWithUserName:(NSString *)userName password:(NSString *)password completeBlock:(void (NS_NOESCAPE^)(UserRecord *userRecord, STError *error))complete
{
    NSFetchRequest *userRequest = [UserRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    [userRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<UserRecord *> *userRecords = [self.context executeFetchRequest:userRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询失败";
        tError.errorDetail = error;
        complete(nil, tError);
    } else {
        if (userRecords.count) {
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"此账号已存在";
            complete(nil, tError);
        } else {
            UserRecord *userRecord = [NSEntityDescription insertNewObjectForEntityForName:@"UserRecord" inManagedObjectContext:self.context];
            userRecord.userName = userName;
            UserInfo *userInfo = [[UserInfo alloc] initWithContext:self.context];
            userInfo.userName = userName;
            userInfo.userPassword = password;
            userRecord.userInfo = userInfo;
            NSError *error = nil;
            [self.context save:&error];
            if (error) {
                STLog(@"insert failure : %@", error.localizedDescription);
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"数据库插入失败";
                tError.errorDetail = error;
                complete(nil, tError);
            } else {
                complete(userRecord, nil);
            }
        }
    }
}

#pragma mark - User

- (UserInfo *)userInfoWithUserName:(NSString *)userName
{
    NSFetchRequest *userRequest = [UserRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    [userRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<UserRecord *> *userRecords = [self.context executeFetchRequest:userRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        return nil;
    } else {
        if (userRecords.count) {
            UserRecord *userRecord = userRecords.firstObject;
            UserInfo *userInfo = userRecord.userInfo;
            return userInfo;
        } else {
            return nil;
        }
    }
}

- (void)editMyIconWithUserName:(NSString *)userName image:(UIImage *)image completeBlock:(void (^)(UIImage *, STError *))complete
{
    NSFetchRequest *userRequest = [UserRecord fetchRequest];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName = %@", userName];
    [userRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray<UserRecord *> *userRecords = [self.context executeFetchRequest:userRequest error:&error];
    if (error) {
        STLog(@"fetch failure : %@", error.localizedDescription);
        STError *tError = [[Hub getErrorMgr] createError];
        tError.errorTip = @"数据库查询失败";
        tError.errorDetail = error;
        complete(nil, tError);
    } else {
        if (!userRecords.count) {
            STError *tError = [[Hub getErrorMgr] createError];
            tError.errorTip = @"未知错误，此账号不存在";
            complete(nil, tError);
        } else {
            UserRecord *userRecord = userRecords.firstObject;
            UserInfo *userInfo = userRecord.userInfo;
            userRecord.userInfo = nil;
            userInfo.userIcon = UIImageJPEGRepresentation(image, 1.0);
            userRecord.userInfo = userInfo;
            NSError *error = nil;
            [self.context save:&error];
            if (error) {
                STLog(@"insert failure : %@", error.localizedDescription);
                STError *tError = [[Hub getErrorMgr] createError];
                tError.errorTip = @"数据库写入失败";
                tError.errorDetail = error;
                complete(nil, tError);
            } else {
                complete(image, nil);
            }
        }
    }
}

@end
