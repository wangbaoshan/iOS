//
//  UIImage+BS.m
//  hindi4iOS
//
//  Created by 王宝山 on 16/7/30.
//  Copyright © 2016年 onairm. All rights reserved.
//

#import "UIImage+BS.h"

@implementation UIImage (BS)

/** 返回一张能够自由拉伸的图片 */
+ (UIImage *)resizedImageWithImageStr:(NSString *)imageStr withLeft:(CGFloat)left andTop:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:imageStr];
    return [self resizedImageWithImage:image withLeft:left andTop:top];
}
+ (UIImage *)resizedImageWithImage:(UIImage *)image withLeft:(CGFloat)left andTop:(CGFloat)top
{
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
+ (UIImage *)resizedImageWithImageStr:(NSString *)imageStr
{
    return [self resizedImageWithImageStr:imageStr withLeft:0.5 andTop:0.5];
}
+ (UIImage *)resizedImageWithImage:(UIImage *)image
{
    return [self resizedImageWithImage:image withLeft:0.5 andTop:0.5];
}

/** 根据颜色返回一张图片 */
+ (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, alpha);
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithRGBColorRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, 30, 30);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, red, green, blue, alpha);
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextSetAlpha(ctx, alpha);
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 返回一张打水印的图片 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage waterImage:(UIImage *)waterImage
{
    UIGraphicsBeginImageContext(originalImage.size);
    [originalImage drawInRect:CGRectMake(0, 0, originalImage.size.width, originalImage.size.height)];
    [waterImage drawInRect:CGRectMake(originalImage.size.width - waterImage.size.width, originalImage.size.height - waterImage.size.height, waterImage.size.width, waterImage.size.height)];
    UIImage *logImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return logImage;
}
+ (UIImage *)imageWithOriginalImageStr:(NSString *)originalImageStr waterImageStr:(NSString *)waterImageStr
{
    UIImage *originalImage = [UIImage imageNamed:originalImageStr];
    UIImage *waterImage = [UIImage imageNamed:waterImageStr];
    return [self imageWithOriginalImage:originalImage waterImage:waterImage];
}

/** 返回一张截屏图片 */
+ (UIImage *)imageFromView:(UIView *)view
{
//    UIGraphicsBeginImageContext(view.frame.size); // 失真
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 返回一张圆形带环框图片 */
+ (UIImage *)imageWithImage:(UIImage *)image circleWidth:(CGFloat)circleWidth circleColor:(UIColor *)circleColor
{
    CGRect bgRect = CGRectMake(0, 0, image.size.width + circleWidth * 2, image.size.height + circleWidth * 2);
    CGRect imgRect = CGRectMake(circleWidth, circleWidth, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(bgRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, circleColor.CGColor);
    CGContextAddEllipseInRect(ctx, bgRect);
    CGContextFillPath(ctx);
    CGContextAddEllipseInRect(ctx, imgRect);
    CGContextClip(ctx);
    [image drawInRect:imgRect];
    UIImage *desImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return desImage;
}
+ (UIImage *)imageWithImageStr:(NSString *)imageStr circleWidth:(CGFloat)circleWidth circleColor:(UIColor *)circleColor
{
    UIImage *image = [UIImage imageNamed:imageStr];
    return [self imageWithImage:image circleWidth:circleWidth circleColor:circleColor];
}

/// 改变图片的透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
