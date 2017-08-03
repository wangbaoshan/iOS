//
//  StatusPhotosView.h
//  CommentCell
//
//  Created by power on 2017/5/22.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StatusPhoto;

@interface StatusPhotosView : UIView

@property (nonatomic, strong) NSArray<StatusPhoto *> *photos;

+ (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth maxCount:(NSUInteger)maxCount margin:(CGFloat)margin;

@end
