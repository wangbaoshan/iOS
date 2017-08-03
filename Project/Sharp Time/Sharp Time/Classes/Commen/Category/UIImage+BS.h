//
//  UIImage+BS.h
//  hindi4iOS
//
//  Created by 王宝山 on 16/7/30.
//  Copyright © 2016年 onairm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (BS)

/** 返回一张能够自由拉伸的图片 */
+ (UIImage *)resizedImageWithImageStr:(NSString *)imageStr withLeft:(CGFloat)left andTop:(CGFloat)top;
+ (UIImage *)resizedImageWithImage:(UIImage *)image withLeft:(CGFloat)left andTop:(CGFloat)top;
+ (UIImage *)resizedImageWithImageStr:(NSString *)imageStr;
+ (UIImage *)resizedImageWithImage:(UIImage *)image;

/** 根据颜色返回一张图片 */
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha;
+ (UIImage *)imageWithRGBColorRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha;

/** 返回一张打水印的图片 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage waterImage:(UIImage *)waterImage;
+ (UIImage *)imageWithOriginalImageStr:(NSString *)originalImageStr waterImageStr:(NSString *)waterImageStr;

/** 返回一张截屏图片 */
+ (UIImage *)imageFromView:(UIView *)view;

/** 返回一张圆形带环框图片，原图片须保证为正方形 */
+ (UIImage *)imageWithImage:(UIImage *)image circleWidth:(CGFloat)circleWidth circleColor:(UIColor *)circleColor;
+ (UIImage *)imageWithImageStr:(NSString *)imageStr circleWidth:(CGFloat)circleWidth circleColor:(UIColor *)circleColor;

@end

NS_ASSUME_NONNULL_END
