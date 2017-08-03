//
//  WBStatusRetweetedView.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusRetweetedView.h"

#import "WBStatusRetweetedFrame.h"
#import "WBStatus.h"
#import "WBStatusPhotosView.h"

@interface WBStatusRetweetedView ()

@property (nonatomic, weak) UILabel *retweetTextLabel;

@property (nonatomic, weak) WBStatusPhotosView *photosView;

@end

@implementation WBStatusRetweetedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = kStatusRetweetedBackgroundViewColor;
        [self createView];
        
    }
    return self;
}

- (void)createView
{
    UILabel *retweetTextLabel = [[UILabel alloc] init];
    retweetTextLabel.font = kStatusRetweetedTextFont;
    retweetTextLabel.textColor = kStatusRetweetedTextColor;
    retweetTextLabel.numberOfLines = 0;
    [self addSubview:retweetTextLabel];
    self.retweetTextLabel = retweetTextLabel;
    
    WBStatusPhotosView *photosView = [[WBStatusPhotosView alloc] init];
    [self addSubview:photosView];
    self.photosView = photosView;
}

- (void)setRetweetedFrame:(WBStatusRetweetedFrame *)retweetedFrame
{
    _retweetedFrame = retweetedFrame;
    
    self.frame = retweetedFrame.selfFrame;
    
    WBStatus *retweetedStatus = retweetedFrame.retweetedStatus;
    
    self.retweetTextLabel.frame = retweetedFrame.retweetTextFrame;
    self.retweetTextLabel.text = retweetedStatus.text;
    
    self.photosView.frame = retweetedFrame.photosFrame;
    self.photosView.pic_urls = retweetedStatus.pic_urls;
}

@end
