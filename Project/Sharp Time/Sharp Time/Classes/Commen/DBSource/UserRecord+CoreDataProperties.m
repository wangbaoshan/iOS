//
//  UserRecord+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UserRecord+CoreDataProperties.h"

@implementation UserRecord (CoreDataProperties)

+ (NSFetchRequest<UserRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserRecord"];
}

@dynamic userName;
@dynamic userInfo;
@dynamic userSettingInfo;

@end
