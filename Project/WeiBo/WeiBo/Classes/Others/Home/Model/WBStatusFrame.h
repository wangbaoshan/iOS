//
//  WBStatusFrame.h
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WBStatus;
@class WBStatusDetailFrame;

@interface WBStatusFrame : NSObject

@property (nonatomic, strong) WBStatus *status;
@property (nonatomic, strong) WBStatusDetailFrame *detailFrame;
@property (nonatomic, assign) CGRect toolBarFrame;
@property (nonatomic, assign) CGRect lineFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@end
