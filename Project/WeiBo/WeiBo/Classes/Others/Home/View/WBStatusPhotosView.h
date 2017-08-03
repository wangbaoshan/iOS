//
//  WBStatusPhotosView.h
//  WeiBo
//
//  Created by wbs on 17/2/15.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kStatusPhotosViewDidClickPhoto;

@class WBStatusPhoto;

@interface WBStatusPhotosView : UIView

@property (nonatomic, strong) NSArray<WBStatusPhoto *> *pic_urls;

+ (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth maxCount:(NSUInteger)maxCount margin:(CGFloat)margin;

@end
