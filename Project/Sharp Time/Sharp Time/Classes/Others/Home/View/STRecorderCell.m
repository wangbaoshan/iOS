//
//  STRecorderCell.m
//  Sharp Time
//
//  Created by power on 2017/5/2.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STRecorderCell.h"
#import "PunchRecord+CoreDataProperties.h"
#import "PunchInfo+CoreDataProperties.h"

@interface STRecorderCell ()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *morningRecorderLabel;
@property (weak, nonatomic) IBOutlet UILabel *afternoonRecorderLabel;
@property (weak, nonatomic) IBOutlet UIView *seperateLine;


@end

@implementation STRecorderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.seperateLine.backgroundColor = [UIColor lightGrayColor];
    self.dayLabel.font = [UIFont systemFontOfSize:17];
    self.morningRecorderLabel.font = [UIFont systemFontOfSize:16];
    self.afternoonRecorderLabel.font = [UIFont systemFontOfSize:16];
    self.morningRecorderLabel.textAlignment = NSTextAlignmentLeft;
    self.afternoonRecorderLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setRecord:(PunchRecord *)record
{
    _record = record;
    
    self.dayLabel.text = record.punchInfo.dayString;
    self.morningRecorderLabel.text = record.punchInfo.morningRecord;
    self.afternoonRecorderLabel.text = record.punchInfo.afternoonRecord;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
