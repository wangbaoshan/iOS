//
//  UIImage+Stretch.h
//  CommentCell
//
//  Created by power on 2017/6/5.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Stretch)

/** 返回一张能够自由拉伸的图片 */
+ (UIImage *)resizedImageWithImageStr:(NSString *)imageStr withLeft:(CGFloat)left andTop:(CGFloat)top;
+ (UIImage *)resizedImageWithImage:(UIImage *)image withLeft:(CGFloat)left andTop:(CGFloat)top;
+ (UIImage *)resizedImageWithImageStr:(NSString *)imageStr;
+ (UIImage *)resizedImageWithImage:(UIImage *)image;

@end
