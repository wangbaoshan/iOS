//
//  WBStatusOriginalFrame.h
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBStatus;

@interface WBStatusOriginalFrame : NSObject

@property (nonatomic, strong) WBStatus *status;

@property (nonatomic, assign) CGRect iconFrame;
@property (nonatomic, assign) CGRect nameFrame;
@property (nonatomic, assign) CGRect timeFrame;
@property (nonatomic, assign) CGRect sourceFrame;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGRect photosFrame;

@property (nonatomic, assign) CGRect selfFrame;

@end
