//
//  WBStatusToolBarButton.m
//  WeiBo
//
//  Created by wbs on 17/2/28.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusToolBarButton.h"

@interface WBStatusToolBarButton ()

@property (nonatomic, weak) UIImageView *line;

@end

@implementation WBStatusToolBarButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *line = [[UIImageView alloc] init];
        line.contentMode = UIViewContentModeCenter;
        line.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
        [self addSubview:line];
        self.line = line;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.line.frame = CGRectMake(self.bounds.size.width, 0, 1, self.bounds.size.height);
    
}

@end
