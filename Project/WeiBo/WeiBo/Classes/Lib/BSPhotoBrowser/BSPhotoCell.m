//
//  BSPhotoCell.m
//  WeiBo
//
//  Created by power on 2017/7/30.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSPhotoCell.h"

#import "BSPhotoBrowser.h"
#import "BSPhoto.h"
#import "BSPhotoBrowserHUD.h"

#define kHudWidth 60.0f

#define kMaxZoomScale 2.5f
#define kMinZoomScale 1.0f

@interface BSPhotoCell ()<UIScrollViewDelegate>

@end

@implementation BSPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        scrollView.maximumZoomScale = kMaxZoomScale;
        scrollView.minimumZoomScale = kMinZoomScale;
        scrollView.delegate = self;
        [self.contentView addSubview:scrollView];
        _scrollView = scrollView;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.scrollView addSubview:imageView];
        _imageView = imageView;
        
        BSPhotoBrowserHUD *hud = [[BSPhotoBrowserHUD alloc] initWithFrame:CGRectMake((frame.size.width - kHudWidth) / 2, (frame.size.height - kHudWidth) / 2, kHudWidth, kHudWidth)];
        hud.backgroundColor = [UIColor clearColor];
        hud.hidden = YES;
        [self.contentView addSubview:hud];
        _hud = hud;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [self addGestureRecognizer:singleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

- (void)doubleTap
{
    CGFloat zoomScale = self.scrollView.zoomScale;
    if (zoomScale == kMaxZoomScale) {
        zoomScale = kMinZoomScale;
    } else {
        zoomScale = kMaxZoomScale;
    }
    [self.scrollView setZoomScale:zoomScale animated:YES];
}

- (void)singleTap
{
    if ([self.delegate respondsToSelector:@selector(photoCellDidSingleTap:)]) {
        [self.delegate photoCellDidSingleTap:self];
    }
}

- (void)setPhoto:(BSPhoto *)photo
{
    _photo = photo;
    
    self.hud.hidden = YES;
    self.scrollView.zoomScale = kMinZoomScale;
    [self setupSubviewWithImage:photo.srcView.image];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:photo.remoteUrlString] placeholderImage:photo.srcView.image options:SDWebImageRetryFailed| SDWebImageLowPriority| SDWebImageHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        CGFloat progress = receivedSize * 1.0 / expectedSize;
        if (progress >= 0.0 && progress <= 1) {
            self.hud.hidden = NO;
            self.hud.progress = progress;
        } else {
            self.hud.hidden = YES;
        }
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.hud.hidden = YES;
        [self setupSubviewWithImage:image];
        
    }];
}

#pragma mark - Private

- (void)setupSubviewWithImage:(UIImage *)image
{
    if (!image) return;
    CGSize imageSize = image.size;
    CGFloat h = imageSize.height / imageSize.width * self.scrollView.bounds.size.width;
    if (h >= self.scrollView.bounds.size.height) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, h);
        self.imageView.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, h);
    } else {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        self.imageView.frame = CGRectMake(0, (self.scrollView.bounds.size.height - h) * 0.5, self.scrollView.bounds.size.width, h);
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}


@end
