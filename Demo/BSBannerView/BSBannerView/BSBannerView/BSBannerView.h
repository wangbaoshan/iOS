//
//  BSBannerView.h
//  BSBannerView
//
//  Created by bs on 16/9/7.
//  Copyright © 2016年 onairm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BSBannerViewPhotosTypeRemote = 1,
    BSBannerViewPhotosTypeLocal
} BSBannerViewPhotosType;

@class BSBannerView;

@protocol BSBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(BSBannerView *)bannerView didTapIndex:(NSInteger)index;

@end

@interface BSBannerView : UIView

/// 本地图片数组
@property (nonatomic, copy) NSArray<UIImage *> *imageArray;
/// 远程url字符串数组
@property (nonatomic, copy) NSArray<NSString *> *imageUrl;
/// 占位图片
@property (nonatomic, strong, nullable) UIImage *placeholderImage;

@property (nonatomic, strong, readonly) UIImageView *totalPlaceImageView;
@property (nonatomic, assign, readonly) BSBannerViewPhotosType photosType;

/// 是否自动滚动
@property (nonatomic, assign, getter=isAutoScroll) BOOL autoScroll;
/// 几秒轮播一次
@property (nonatomic, assign) CGFloat scrollSeparateTime;

@property (nonatomic, weak, nullable) id<BSBannerViewDelegate> delegate;

+ (__kindof BSBannerView *)bannerView;
- (__kindof BSBannerView *)initWithFrame:(CGRect)frame imageArray:(NSArray<UIImage *> *)imageArray;
- (__kindof BSBannerView *)initWithFrame:(CGRect)frame imageUrl:(NSArray<NSString *> *)imageUrl;

/// 销毁对象前先解除timer对对象的引用，否则对象无法销毁
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
