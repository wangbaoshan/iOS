//
//  WBStatusFrame.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusFrame.h"

#import "WBStatusDetailFrame.h"

@implementation WBStatusFrame

- (void)setStatus:(WBStatus *)status
{
    _status = status;
    
    [self createFrame];
    
    self.cellHeight = CGRectGetMaxY(self.lineFrame);
}

- (void)createFrame
{
    WBStatusDetailFrame *detailFrame = [[WBStatusDetailFrame alloc] init];
    detailFrame.status = self.status;
    self.detailFrame = detailFrame;
    
    self.toolBarFrame = CGRectMake(0, CGRectGetMaxY(self.detailFrame.selfFrame), kScreenWidth, 35);
    self.lineFrame = CGRectMake(0, CGRectGetMaxY(self.toolBarFrame), kScreenWidth, 10);
}

@end
