//
//  UserInfo+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UserInfo+CoreDataProperties.h"

@implementation UserInfo (CoreDataProperties)

+ (NSFetchRequest<UserInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
}

@dynamic currentLogin;
@dynamic lastLogined;
@dynamic userIcon;
@dynamic userName;
@dynamic userPassword;
@dynamic userRecord;

@end
