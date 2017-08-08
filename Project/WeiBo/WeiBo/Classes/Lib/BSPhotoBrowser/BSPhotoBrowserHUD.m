//
//  BSPhotoBrowserHUD.m
//  BSPhotoBrowser
//
//  Created by power on 2017/8/8.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSPhotoBrowserHUD.h"

#define kOutsideMargin 5.0f
#define kInsideMargin 2.0f

@implementation BSPhotoBrowserHUD

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1.0);
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1.0);
    
    CGPoint centerP = CGPointMake(rect.size.width * 0.5, rect.size.width * 0.5);
    CGFloat outRadius = MIN((rect.size.width - kOutsideMargin * 2) * 0.5, (rect.size.height - kOutsideMargin * 2) * 0.5);
    CGFloat inRadius = outRadius - kInsideMargin;
    CGFloat startAngle = - M_PI_2;
    CGFloat endAngle = startAngle + M_PI * 2 * self.progress;
    
    CGContextAddEllipseInRect(ctx, CGRectMake(centerP.x - outRadius, centerP.y - outRadius, outRadius * 2, outRadius * 2));
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, centerP.x, centerP.y);
    CGContextAddArc(ctx, centerP.x, centerP.y, inRadius, startAngle, endAngle, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

#pragma mark - Setter

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}


@end
