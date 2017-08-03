//
//  WBStatusOriginalView.m
//  WeiBo
//
//  Created by wbs on 17/2/14.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusOriginalView.h"

#import "WBStatusOriginalFrame.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "WBStatusPhotosView.h"

@interface WBStatusOriginalView ()

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *sourceLabel;
@property (nonatomic, weak) UILabel *textLabel;

@property (nonatomic, weak) WBStatusPhotosView *photosView;

@end

@implementation WBStatusOriginalView

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
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.layer.cornerRadius = kStatusIconW * 0.5;
    iconView.clipsToBounds = YES;
    [self addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = kStatusOrginalNameFont;
    nameLabel.textColor = kStatusUserNameColor;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = kStatusTimeColor;
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.textColor = kStatusSourceColor;
    [self addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = kStatusOriginalTextColor;
    textLabel.font = kStatusOrginalTextFont;
    textLabel.numberOfLines = 0;
    [self addSubview:textLabel];
    self.textLabel = textLabel;
    
    WBStatusPhotosView *photosView = [[WBStatusPhotosView alloc] init];
    [self addSubview:photosView];
    self.photosView = photosView;
}

- (void)setOriginalFrame:(WBStatusOriginalFrame *)originalFrame
{
    _originalFrame = originalFrame;
    
    self.frame = originalFrame.selfFrame;
    
    WBStatus *status = originalFrame.status;
    
    self.iconView.frame = originalFrame.iconFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:status.user.profile_image_url]];
    
    self.nameLabel.frame = originalFrame.nameFrame;
    self.nameLabel.text = status.user.name;
    
    self.textLabel.frame = originalFrame.textFrame;
    self.textLabel.text = status.text;
    
    self.photosView.frame = originalFrame.photosFrame;
    self.photosView.pic_urls = status.pic_urls;
}


@end
