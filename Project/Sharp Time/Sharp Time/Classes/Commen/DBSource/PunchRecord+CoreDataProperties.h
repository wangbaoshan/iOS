//
//  PunchRecord+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "PunchRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PunchRecord (CoreDataProperties)

+ (NSFetchRequest<PunchRecord *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) PunchInfo *punchInfo;

@end

NS_ASSUME_NONNULL_END
