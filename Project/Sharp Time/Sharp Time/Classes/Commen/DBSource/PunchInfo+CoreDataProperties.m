//
//  PunchInfo+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "PunchInfo+CoreDataProperties.h"

@implementation PunchInfo (CoreDataProperties)

+ (NSFetchRequest<PunchInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PunchInfo"];
}

@dynamic afternoonRecord;
@dynamic company;
@dynamic dayString;
@dynamic morningRecord;
@dynamic recordTime;
@dynamic userName;
@dynamic yearMonthString;
@dynamic punchRecord;

@end
