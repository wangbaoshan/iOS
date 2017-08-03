//
//  CompanyInfo+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "CompanyInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CompanyInfo (CoreDataProperties)

+ (NSFetchRequest<CompanyInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *companyAddress;
@property (nullable, nonatomic, copy) NSString *companyName;
@property (nonatomic) BOOL selected;
@property (nullable, nonatomic, retain) CompanyRecord *companyRecord;

@end

NS_ASSUME_NONNULL_END
