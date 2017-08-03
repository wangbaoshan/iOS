//
//  StatusPhotoView.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusPhotoView.h"

#import "StatusModel.h"
#import "UIImageView+WebCache.h"

@implementation StatusPhotoView

- (void)setPhoto:(StatusPhoto *)photo
{
    _photo = photo;
    
    [self sd_setImageWithURL:[NSURL URLWithString:photo.imageUrlString]];
}

@end
