//
//  WBStatusPhotoView.m
//  WeiBo
//
//  Created by wbs on 17/2/15.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusPhotoView.h"

#import "WBStatusPhoto.h"

@implementation WBStatusPhotoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setPhoto:(WBStatusPhoto *)photo
{
    _photo = photo;
    
    [self sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"photo_filter_image_empty"]];
}

@end
