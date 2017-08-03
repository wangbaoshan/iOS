//
//  WBStatusDetailFrame.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusDetailFrame.h"

#import "WBStatusOriginalFrame.h"
#import "WBStatusRetweetedFrame.h"
#import "WBStatus.h"

@implementation WBStatusDetailFrame

- (void)setStatus:(WBStatus *)status
{
    _status = status;
    
    [self createFrame];
}

- (void)createFrame
{
    WBStatusOriginalFrame *originalFrame = [[WBStatusOriginalFrame alloc] init];
    originalFrame.status = self.status;
    self.originalFrame = originalFrame;
    
    CGFloat h = 0;
    CGFloat w = kScreenWidth;
    if (self.status.retweeted_status) {
        WBStatusRetweetedFrame *retweetedFrame = [[WBStatusRetweetedFrame alloc] init];
        retweetedFrame.retweetedStatus = self.status.retweeted_status;
        
        // 计算转发微博frame的y值
        CGRect f = retweetedFrame.selfFrame;
        f.origin.y = CGRectGetMaxY(self.originalFrame.selfFrame);
        retweetedFrame.selfFrame = f;
        
        self.retweetedFrame = retweetedFrame;
        
        h = CGRectGetMaxY(self.retweetedFrame.selfFrame);
    } else {
        
        h = CGRectGetMaxY(self.originalFrame.selfFrame);
    }

    // 自己的frame
    CGFloat x = 0;
    CGFloat y = 0;
    
    self.selfFrame = CGRectMake(x, y, w, h);
}

@end
