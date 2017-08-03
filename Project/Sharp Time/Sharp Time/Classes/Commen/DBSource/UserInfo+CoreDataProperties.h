//
//  UserInfo+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UserInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest;

@property (nonatomic) BOOL currentLogin;
@property (nonatomic) BOOL lastLogined;
@property (nullable, nonatomic, retain) NSData *userIcon;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *userPassword;
@property (nullable, nonatomic, retain) UserRecord *userRecord;

@end

NS_ASSUME_NONNULL_END
