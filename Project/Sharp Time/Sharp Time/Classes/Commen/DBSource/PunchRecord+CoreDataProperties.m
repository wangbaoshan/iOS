//
//  PunchRecord+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "PunchRecord+CoreDataProperties.h"

@implementation PunchRecord (CoreDataProperties)

+ (NSFetchRequest<PunchRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PunchRecord"];
}

@dynamic company;
@dynamic userName;
@dynamic punchInfo;

@end
