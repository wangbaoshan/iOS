//
//  BSPhotoBrowser.h
//  WeiBo
//
//  Created by power on 2017/7/30.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BSPhoto;

@interface BSPhotoBrowser : UIViewController

/// initialize
+ (__kindof BSPhotoBrowser *)browserWithPhotos:(NSArray<BSPhoto *> *)photos;
- (__kindof BSPhotoBrowser *)initWithPhotos:(NSArray<BSPhoto *> *)photos;

/// 当前图片索引
@property (nonatomic, assign) NSInteger currentIndex;
/// 每个item图片之间的间距
@property (nonatomic, assign) CGFloat minimumLineSpacing;

/// 将以模态试图方式弹出
- (void)showViewController:(UIViewController *)vc;
/// 以模态试图方式弹出，dismiss方法有效
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
