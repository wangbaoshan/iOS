//
//  BSPlayer.h
//  Player
//
//  Created by wbs on 16/12/27.
//  Copyright © 2016年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BSPlayer;

@protocol BSPlayerDelegate <NSObject>

@optional
/// 屏幕发生改变时调用此代理方法，外部根据返回屏幕方向（UIInterfaceOrientationPortrait｜UIInterfaceOrientationLandscapeLeft｜UIInterfaceOrientationLandscapeRight）作UI处理
- (void)player:(BSPlayer *)player deviceOrientationDidChange:(UIInterfaceOrientation)orientation;

@end

@interface BSPlayer : UIView

@property (nonatomic, weak, readonly) UIImageView *backgroundImageView;

@property (nonatomic, weak) UIViewController *containerController;
@property (nonatomic, weak, nullable) id<BSPlayerDelegate> delegate;

+ (__kindof BSPlayer *)player;

- (void)replaceItemWithUrl:(NSURL *)url;
- (void)startPlay;

- (void)tryToPlay;
- (void)tryToPause;

@end

@interface BSPlayer (Extension)

- (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha;

@end


@interface BSPlayerItem : AVPlayerItem

@end

NS_ASSUME_NONNULL_END
