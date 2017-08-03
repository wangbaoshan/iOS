//
//  CompanyInfo+CoreDataProperties.m
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "CompanyInfo+CoreDataProperties.h"

@implementation CompanyInfo (CoreDataProperties)

+ (NSFetchRequest<CompanyInfo *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CompanyInfo"];
}

@dynamic companyAddress;
@dynamic companyName;
@dynamic selected;
@dynamic companyRecord;

@end
