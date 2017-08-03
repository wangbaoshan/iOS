//
//  PunchInfo+CoreDataProperties.h
//  Sharp Time
//
//  Created by power on 2017/5/19.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "PunchInfo+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PunchInfo (CoreDataProperties)

+ (NSFetchRequest<PunchInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *afternoonRecord;
@property (nullable, nonatomic, copy) NSString *company;
@property (nullable, nonatomic, copy) NSString *dayString;
@property (nullable, nonatomic, copy) NSString *morningRecord;
@property (nonatomic) double recordTime;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, copy) NSString *yearMonthString;
@property (nullable, nonatomic, retain) PunchRecord *punchRecord;

@end

NS_ASSUME_NONNULL_END
