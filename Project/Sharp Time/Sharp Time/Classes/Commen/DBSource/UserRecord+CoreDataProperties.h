//
//  UserRecord+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UserRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserRecord (CoreDataProperties)

+ (NSFetchRequest<UserRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) UserInfo *userInfo;
@property (nullable, nonatomic, retain) UserSettingInfo *userSettingInfo;

@end

NS_ASSUME_NONNULL_END
