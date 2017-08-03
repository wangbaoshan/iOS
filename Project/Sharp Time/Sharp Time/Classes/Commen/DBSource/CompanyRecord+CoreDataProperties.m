//
//  CompanyRecord+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "CompanyRecord+CoreDataProperties.h"

@implementation CompanyRecord (CoreDataProperties)

+ (NSFetchRequest<CompanyRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CompanyRecord"];
}

@dynamic company;
@dynamic userName;
@dynamic companyInfo;

@end
