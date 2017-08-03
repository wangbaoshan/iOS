//
//  WBStatusDetailView.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusDetailView.h"

#import "WBStatusOriginalView.h"
#import "WBStatusRetweetedView.h"

#import "WBStatusDetailFrame.h"

@interface WBStatusDetailView ()

@property (nonatomic, weak) WBStatusOriginalView *originalView;
@property (nonatomic, weak) WBStatusRetweetedView *retweetedView;


@end

@implementation WBStatusDetailView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self createView];
        
    }
    return self;
}

- (void)createView
{
    WBStatusOriginalView *originalView = [[WBStatusOriginalView alloc] init];
    [self addSubview:originalView];
    self.originalView = originalView;
    
    WBStatusRetweetedView *retweetedView = [[WBStatusRetweetedView alloc] init];
    [self addSubview:retweetedView];
    self.retweetedView = retweetedView;
    
}

- (void)setDetailFrame:(WBStatusDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    self.frame = detailFrame.selfFrame;
    
    self.originalView.originalFrame = detailFrame.originalFrame;
    self.retweetedView.retweetedFrame = detailFrame.retweetedFrame;
}

@end
