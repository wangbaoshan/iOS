//
//  STCollectionViewCell.m
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STCollectionViewCell.h"

#import "STCollectionHubView.h"

@implementation STCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
                
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.frame = self.bounds;
        
        imageView.image = [UIImage imageNamed:@"profile_cover_background@2x.jpg"];
        [self.contentView addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, frame.size.width * 0.5, frame.size.height * 0.5);
        label.font = [UIFont systemFontOfSize:[self textFontSize:18]];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:label];
        
        self.label = label;
    
    }
    return self;
}

- (CGFloat)textFontSize:(CGFloat)fontSize
{
    return fontSize / [STCollectionHubView scale];
}

@end
