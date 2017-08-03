//
//  UserSettingInfo+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UserSettingInfo+CoreDataProperties.h"

@implementation UserSettingInfo (CoreDataProperties)

+ (NSFetchRequest<UserSettingInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserSettingInfo"];
}

@dynamic userRecord;

@end
