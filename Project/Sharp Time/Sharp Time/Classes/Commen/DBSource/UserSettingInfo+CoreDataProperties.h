//
//  UserSettingInfo+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UserSettingInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserSettingInfo (CoreDataProperties)

+ (NSFetchRequest<UserSettingInfo *> *)fetchRequest;

@property (nullable, nonatomic, retain) UserRecord *userRecord;

@end

NS_ASSUME_NONNULL_END
