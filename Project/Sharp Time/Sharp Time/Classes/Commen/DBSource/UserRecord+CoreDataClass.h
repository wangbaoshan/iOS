//
//  UserRecord+CoreDataClass.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserInfo, UserSettingInfo;

NS_ASSUME_NONNULL_BEGIN

@interface UserRecord : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "UserRecord+CoreDataProperties.h"
