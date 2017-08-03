//
//  CompanyRecord+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "CompanyRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CompanyRecord (CoreDataProperties)

+ (NSFetchRequest<CompanyRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) CompanyInfo *companyInfo;

@end

NS_ASSUME_NONNULL_END
