//
//  WBStatusDetailFrame.h
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBStatusOriginalFrame;
@class WBStatusRetweetedFrame;
@class WBStatus;

@interface WBStatusDetailFrame : NSObject

@property (nonatomic, strong) WBStatus *status;

@property (nonatomic, strong) WBStatusOriginalFrame *originalFrame;
@property (nonatomic, strong) WBStatusRetweetedFrame *retweetedFrame;

@property (nonatomic, assign) CGRect selfFrame;

@end
