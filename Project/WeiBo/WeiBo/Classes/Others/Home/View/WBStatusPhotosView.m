//
//  WBStatusPhotosView.m
//  WeiBo
//
//  Created by wbs on 17/2/15.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBStatusPhotosView.h"
#import "WBStatusPhotoView.h"
#import "WBStatusPhoto.h"

#import "WBPhotoBrowser.h"
#import "WBPhoto.h"

#import "BSPhotoBrowser.h"
#import "BSPhoto.h"

#define kStatusPhotosMaxCols(photosCount) ((photosCount==4)?2:3)
#define kStatusMaxPhotosCount 9

static CGFloat _margin = 0.0;
static CGFloat _photosW = 0.0;

NSString *const kStatusPhotosViewDidClickPhoto = @"kStatusPhotosViewDidClickPhoto";

@implementation WBStatusPhotosView

+ (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth maxCount:(NSUInteger)maxCount margin:(CGFloat)margin
{
    _margin = margin;
    
    NSUInteger maxCols = kStatusPhotosMaxCols(maxCount);
    // 总列数
    NSUInteger totalCols = (maxCount >= maxCols ?  maxCols : maxCount);
    // 总行数
    NSUInteger totalRows = (maxCount + maxCols - 1) / maxCols;
    // 计算尺寸
    CGFloat w = (maxWidth - margin * 2) / 3;
    _photosW = w;
    CGFloat photosW = totalCols * w + (totalCols - 1) * margin;
    CGFloat photosH = totalRows * w + (totalRows - 1) * margin;
    return CGSizeMake(photosW, photosH);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        for (int i = 0; i < kStatusMaxPhotosCount; i++) {
            WBStatusPhotoView *photoView = [[WBStatusPhotoView alloc] init];
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
    WBStatusPhotoView *photoView = (WBStatusPhotoView *)recognizer.view;
    
    /// method 1
    NSMutableArray<BSPhoto *> *photos = [NSMutableArray array];
    for (int i = 0; i < self.pic_urls.count; i++) {
        BSPhoto *photo = [[BSPhoto alloc] init];
        photo.srcView = self.subviews[i];
        photo.remoteUrlString = [self.pic_urls[i].thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        [photos addObject:photo];
    }
    
    BSPhotoBrowser *browser = [BSPhotoBrowser browserWithPhotos:photos];
    browser.minimumLineSpacing = 10;
    browser.currentIndex = photoView.tag;
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusPhotosViewDidClickPhoto object:browser];
    
    /// method 2
//    NSMutableArray<WBPhoto *> *photos = [NSMutableArray array];
//    for (int i = 0; i < self.pic_urls.count; i++) {
//        WBPhoto *photo = [[WBPhoto alloc] init];
//        photo.srcView = self.subviews[i];
//        photo.remoteUrlString = [self.pic_urls[i].thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
//        [photos addObject:photo];
//    }
//    
//    WBPhotoBrowser *browser = [WBPhotoBrowser browser];
//    browser.minimumLineSpacing = 10;
//    browser.photos = photos;
//    browser.currentIndex = photoView.tag;
//    [browser show];
    
}

- (void)setPic_urls:(NSArray<WBStatusPhoto *> *)pic_urls
{
    _pic_urls = pic_urls;
    
    for (int i = 0; i<kStatusMaxPhotosCount; i++) {
        WBStatusPhotoView *photoView = self.subviews[i];
        if (i < pic_urls.count) { // 显示图片
            photoView.photo = pic_urls[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count = self.pic_urls.count;
    NSUInteger maxCols = kStatusPhotosMaxCols(count);
    for (int i = 0; i<count; i++) {
        WBStatusPhotoView *photoView = self.subviews[i];
        CGFloat x = (i % maxCols) * (_photosW + _margin);
        CGFloat y = (i / maxCols) * (_photosW + _margin);
        
        photoView.frame = CGRectMake(x, y, _photosW, _photosW);
    }
}


@end
