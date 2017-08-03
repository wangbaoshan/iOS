//
//  StatusPhotosView.m
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "StatusPhotosView.h"

#import "StatusPhotoView.h"
#import "StatusModel.h"

#define kStatusPhotosMaxCols(photosCount) ((photosCount==4)?2:3)
#define kStatusMaxPhotosCount 9

static CGFloat kMargin = 0.0;
static CGFloat kPhotosW = 0.0;

@implementation StatusPhotosView

+ (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth maxCount:(NSUInteger)maxCount margin:(CGFloat)margin
{
    if (maxCount == 0) return CGSizeZero;
    
    kMargin = margin;
    NSUInteger maxCols = kStatusPhotosMaxCols(maxCount);
    // 总列数
    NSUInteger totalCols = (maxCount >= maxCols ?  maxCols : maxCount);
    // 总行数
    NSUInteger totalRows = (maxCount + maxCols - 1) / maxCols;
    // 计算尺寸
    CGFloat w = (maxWidth - margin * 2) / 3;
    kPhotosW = w;
    CGFloat photosW = totalCols * w + (totalCols - 1) * margin;
    CGFloat photosH = totalRows * w + (totalRows - 1) * margin;
    return CGSizeMake(photosW, photosH);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < kStatusMaxPhotosCount; i++) {
            StatusPhotoView *photoView = [[StatusPhotoView alloc] init];
            photoView.tag = i;
            [self addSubview:photoView];
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
        }
    }
    return self;
}

- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    
}

- (void)setPhotos:(NSArray<StatusPhoto *> *)photos
{
    _photos = photos;
    
    for (int i = 0; i<kStatusMaxPhotosCount; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        if (i < photos.count) { // 显示图片
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.photos.count;
    NSUInteger maxCols = kStatusPhotosMaxCols(count);
    for (int i = 0; i<count; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        CGFloat x = (i % maxCols) * (kPhotosW + kMargin);
        CGFloat y = (i / maxCols) * (kPhotosW + kMargin);
        photoView.frame = CGRectMake(x, y, kPhotosW, kPhotosW);
    }
}

@end
