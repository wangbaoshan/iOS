//
//  WBStatusRetweetedFrame.h
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBStatus;

@interface WBStatusRetweetedFrame : NSObject

@property (nonatomic, strong) WBStatus *retweetedStatus;

@property (nonatomic, assign) CGRect retweetTextFrame;
@property (nonatomic, assign) CGRect photosFrame;

@property (nonatomic, assign) CGRect selfFrame;

@end
