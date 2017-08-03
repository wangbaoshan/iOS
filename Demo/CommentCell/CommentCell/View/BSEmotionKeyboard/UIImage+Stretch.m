//
//  UIImage+Stretch.m
//  CommentCell
//
//  Created by power on 2017/6/5.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "UIImage+Stretch.h"

@implementation UIImage (Stretch)

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


@end
