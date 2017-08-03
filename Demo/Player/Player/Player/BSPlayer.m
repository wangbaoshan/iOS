//
//  BSPlayer.m
//  Player
//
//  Created by wbs on 16/12/27.
//  Copyright © 2016年 xiaomaolv. All rights reserved.
//

#import "BSPlayer.h"

typedef enum : NSUInteger {
    BSPlayerUIStatus_initial = 0,
    BSPlayerUIStatus_prepareToPlay,
    BSPlayerUIStatus_playing,
    BSPlayerUIStatus_loadingBuffer,
    BSPlayerUIStatus_loadFailure
} BSPlayerUIStatus;

@interface BSPlayer ()

@property (nonatomic, strong) NSURL *currentUrl;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) BSPlayerItem *currentPlayerItem;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIView *tapStartView;
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic, weak) UIButton *tapStartBtn;
@property (nonatomic, weak) UIView *actionView;
@property (nonatomic, weak) UIButton *voiceBtn;
@property (nonatomic, weak) UIButton *continueplayBtn;
@property (nonatomic, weak) UIView *actionBar;
@property (nonatomic, weak) UIButton *playOrPauseBtn;
@property (nonatomic, weak) UIButton *fullScreenOrExitBtn;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIProgressView *loadingProgress;
@property (nonatomic, weak) UISlider *slider;

@property (nonatomic, strong) id timeObserve; // 播放器定时观察者
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, assign, getter=isAlreadyPlay) BOOL alreadyPlay;
@property (nonatomic, assign, getter=isBecomeActiveNeedToPlay) BOOL becomeActiveNeedToPlay;
@property (nonatomic, assign, getter=isAllowFullScreen) BOOL allowFullScreen; // 受否允许全屏播放

@property (nonatomic, assign) CGRect selfOriginalFrame;


@end

@implementation BSPlayer

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s", __func__);
#endif
    @try {
        [self removeObserverWithPlayerItem:self.currentPlayerItem];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.playerLayer.bounds = self.backgroundImageView.bounds;
    self.playerLayer.position = CGPointMake(self.backgroundImageView.bounds.size.width * 0.5, self.backgroundImageView.bounds.size.height * 0.5);
    [CATransaction commit];
    
    self.tapStartView.frame = self.bounds;
    self.indicatorView.center = CGPointMake(self.tapStartView.frame.size.width * 0.5, self.tapStartView.frame.size.height * 0.5);
    self.tapStartBtn.frame = CGRectMake((self.tapStartView.frame.size.width - 50) * 0.5, (self.tapStartView.frame.size.height - 50) * 0.5, 50, 50);
    
    self.actionView.frame = self.bounds;
    self.voiceBtn.frame = CGRectMake(self.actionView.frame.size.width - 10 - 35, (self.actionView.frame.size.height - 35) * 0.5, 35, 35);
    self.continueplayBtn.bounds = CGRectMake(0, 0, 50, 50);
    self.continueplayBtn.center = CGPointMake(self.actionView.frame.size.width * 0.5, self.actionView.frame.size.height * 0.5);
    self.actionBar.frame = CGRectMake(self.actionView.frame.origin.x, self.actionView.frame.size.height - 35, self.actionView.frame.size.width, 35);
    self.playOrPauseBtn.frame = CGRectMake(0, 0, self.actionBar.frame.size.height, self.actionBar.frame.size.height);
    self.fullScreenOrExitBtn.frame = CGRectMake(self.actionBar.frame.size.width - self.actionBar.frame.size.height, 0, self.actionBar.frame.size.height, self.actionBar.frame.size.height);
    self.timeLabel.frame = CGRectMake(self.fullScreenOrExitBtn.frame.origin.x - 90, 0, 90, self.actionBar.frame.size.height);
    self.slider.frame = CGRectMake(CGRectGetMaxX(self.playOrPauseBtn.frame), 0, self.timeLabel.frame.origin.x - CGRectGetMaxX(self.playOrPauseBtn.frame) - 10, self.actionBar.frame.size.height);
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.selfOriginalFrame = frame;
}

+ (BSPlayer *)player
{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 浮层1，开始背景图片
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:backgroundImageView];
        self.backgroundImageView = backgroundImageView;
        
        // 浮层2，player playerLayer播放层
        self.player = [[AVPlayer alloc] init];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResize; //视频填充模式
        [self.backgroundImageView.layer addSublayer:self.playerLayer];
        
        // 浮层3，开始
        UIView *tapStartView = [[UIView alloc] init];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [tapStartView addSubview:indicatorView];
        self.indicatorView = indicatorView;
        
        UIButton *tapStartBtn = [[UIButton alloc] init];
        [tapStartBtn addTarget:self action:@selector(startPlay) forControlEvents:UIControlEventTouchUpInside];
        [tapStartBtn setImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
        [tapStartView addSubview:tapStartBtn];
        self.tapStartBtn = tapStartBtn;
        [self addSubview:tapStartView];
        self.tapStartView = tapStartView;
        
        // 浮层4，操作
        UIView *actionView = [[UIView alloc] init];
        [actionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionViewTap)]];
        
        UIButton *voiceBtn = [[UIButton alloc] init];
        [voiceBtn setImage:[UIImage imageNamed:@"sound"] forState:UIControlStateNormal];
        [voiceBtn setImage:[UIImage imageNamed:@"sound_selected"] forState:UIControlStateSelected];
        [voiceBtn addTarget:self action:@selector(voiceChange) forControlEvents:UIControlEventTouchUpInside];
        [actionView addSubview:voiceBtn];
        self.voiceBtn = voiceBtn;
        
        UIButton *continueplayBtn = [[UIButton alloc] init];
        [continueplayBtn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        [continueplayBtn setImage:[UIImage imageNamed:@"movieBtn"] forState:UIControlStateNormal];
        [actionView addSubview:continueplayBtn];
        self.continueplayBtn = continueplayBtn;
        self.continueplayBtn.hidden = YES;
        
        UIView *actionBar = [[UIView alloc] init];
        actionBar.backgroundColor = [UIColor colorWithPatternImage:[self imageWithColor:[UIColor blackColor] alpha:0.5]];
        
        UIButton *playOrPauseBtn = [[UIButton alloc] init];
        [playOrPauseBtn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"video_pause"] forState:UIControlStateNormal];
        [playOrPauseBtn setImage:[UIImage imageNamed:@"video_play"] forState:UIControlStateSelected];
        [actionBar addSubview:playOrPauseBtn];
        self.playOrPauseBtn = playOrPauseBtn;
        
        UIButton *fullScreenOrExitBtn = [[UIButton alloc] init];
        [fullScreenOrExitBtn addTarget:self action:@selector(fullScreenOrExit) forControlEvents:UIControlEventTouchUpInside];
        [fullScreenOrExitBtn setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
        [fullScreenOrExitBtn setImage:[UIImage imageNamed:@"nonfullscreen"] forState:UIControlStateSelected];
        [actionBar addSubview:fullScreenOrExitBtn];
        self.fullScreenOrExitBtn = fullScreenOrExitBtn;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.text = [NSString stringWithFormat:@"00:00 / --:--"];
        timeLabel.textColor = [UIColor whiteColor];
        [actionBar addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        UISlider *slider = [[UISlider alloc] init];
        slider.value = 0;
        [slider setThumbImage:[UIImage imageNamed:@"time_slider"] forState:UIControlStateNormal];
        // slider开始滑动事件
        [slider addTarget:self action:@selector(touchBeganProgress) forControlEvents:UIControlEventTouchDown];
        // slider滑动中事件
        [slider addTarget:self action:@selector(touchChangeProgress) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [slider addTarget:self action:@selector(touchEndProgress) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [actionBar addSubview:slider];
        self.slider = slider;
        
        [actionView addSubview:actionBar];
        self.actionBar = actionBar;
        
        [self addSubview:actionView];
        self.actionView = actionView;
        
        [self changeUIWithStatus:BSPlayerUIStatus_initial];
        
        [self addWillResignActiveOrBecomeActiveObserver];
        [self addOrientationChangeObserver];
        
    }
    return self;
}

- (void)touchBeganProgress
{
    [self tryToPause];
}

- (void)touchChangeProgress
{
    // 移动滑动条会迅速触发此方法，所以先调用cancelPendingSeeks方法。如果前一个搜索请求没有完成，可避免出现搜索操作堆积情况的出现，优化性能
    [self.player.currentItem cancelPendingSeeks];
    [self.player seekToTime:CMTimeMakeWithSeconds(self.slider.value * (self.player.currentItem.duration.value / self.player.currentItem.duration.timescale), self.player.currentItem.duration.timescale)];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self convertTime:[self playItemCurrentTime]], [self convertTime:[self playItemDurationTime]]];
}

- (void)touchEndProgress
{
    [self tryToPlay];
}

- (void)voiceChange
{
    self.voiceBtn.selected = !self.voiceBtn.selected;
    if (self.voiceBtn.isSelected) {
        self.player.volume = 0.0;
    } else {
        self.player.volume = 1.0;
    }
}

- (void)actionViewTap
{
    [UIView animateWithDuration:0.35 animations:^{
        if (self.actionBar.alpha == 0.0) {
            self.actionBar.alpha = 1.0;
            self.voiceBtn.alpha = 1.0;
        } else {
            self.actionBar.alpha = 0.0;
            self.voiceBtn.alpha = 0.0;
        }
    }];
}

- (void)addWillResignActiveOrBecomeActiveObserver
{
    // 监听是否触发home键挂起程序
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    // 监听是否重新进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)addOrientationChangeObserver
{
    // 监听屏幕方向发生了变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)removeOrientationChangeObserver
{
    // 移除屏幕方向发生变化的监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)noti
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    
    switch (orient) {
        case UIDeviceOrientationPortrait: // 竖屏正常
        {
#if DEBUG
            NSLog(@"竖屏正常");
#endif
            [self toOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: // 横屏向左
        {
#if DEBUG
            NSLog(@"横屏向左");
#endif
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        case UIDeviceOrientationLandscapeRight: // 横屏向右
        {
#if DEBUG
            NSLog(@"横屏向右");
#endif
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown: // 竖屏向下
            break;
            
        default:
            break;
    }
    /*
     UIDeviceOrientationUnknown,
     UIDeviceOrientationPortrait,            // Device oriented vertically, home button on the bottom
     UIDeviceOrientationPortraitUpsideDown,  // Device oriented vertically, home button on the top
     UIDeviceOrientationLandscapeLeft,       // Device oriented horizontally, home button on the right
     UIDeviceOrientationLandscapeRight,      // Device oriented horizontally, home button on the left
     UIDeviceOrientationFaceUp,              // Device oriented flat, face up
     UIDeviceOrientationFaceDown             // Device oriented flat, face down
     */
}


- (void)toOrientation:(UIInterfaceOrientation)orientation
{
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (currentOrientation == orientation) return;
    
    [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO]; // 改变状态栏方向
    
    // 旋转动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.transform = [self getOrientation];
    [UIView commitAnimations];
    
    if (orientation == UIInterfaceOrientationPortrait) {
        self.frame = self.selfOriginalFrame;
        self.fullScreenOrExitBtn.selected = NO;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        self.center = self.containerController.view.center;
        self.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.fullScreenOrExitBtn.selected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(player:deviceOrientationDidChange:)]) {
        [self.delegate player:self deviceOrientationDidChange:orientation];
    }
    
}

- (void)willResignActive
{
    [self removeOrientationChangeObserver];
    [self tryToPause];
}

- (void)didBecomeActive
{
    [self addOrientationChangeObserver];
    [self tryToPlay];
}

- (void)tryToPlay
{
    if (self.playOrPauseBtn.isSelected) { // 处于暂停状态
        if (self.isBecomeActiveNeedToPlay) {
            [self playOrPause];
        }
    } else { // 处于播放状态
        
    }
}

- (void)tryToPause
{
    if (self.playOrPauseBtn.isSelected) { // 处于暂停状态
        self.becomeActiveNeedToPlay = NO;
    } else { // 处于播放状态，要暂停
        self.becomeActiveNeedToPlay = YES;
        [self playOrPause];
    }
}

- (void)activeHUD
{
    self.indicatorView.hidden = NO;
    [self.indicatorView startAnimating];
}

- (void)hideHUD
{
    [self.indicatorView stopAnimating];
    self.indicatorView.hidden = YES;
}

/** 开始播放要调用此方法，不要单独执行[self.player play]; */
- (void)own_play
{
    [self createPlayerTimeObserver];
    [self.player play];
}

/** 暂停播放要调用此方法 */
- (void)own_pause
{
    [self.player pause];
    [self removePlayerTimeObserver];
}

/** 给player添加监听，用于更新播放时间 */
- (void)createPlayerTimeObserver
{
    if (!self.progressTimer) {
        self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    }
}
/** 移除player的时间监听 */
- (void)removePlayerTimeObserver
{
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)updateProgressInfo
{
    double duration = [self playItemDurationTime];
    double current = [self playItemCurrentTime];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [self convertTime:current], [self convertTime:duration]];
    self.slider.value = current / duration;
}

- (double)playItemDurationTime
{
    return self.currentPlayerItem.duration.value / self.currentPlayerItem.duration.timescale;
}

- (double)playItemCurrentTime
{
    return self.currentPlayerItem.currentTime.value / self.currentPlayerItem.currentTime.timescale;
}

/** 转换时间 */
- (NSString *)convertTime:(double)second
{
    if (second <= 0) return @"00:00";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    if (second / 3600 >= 1) {
        [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    } else {
        [self.dateFormatter setDateFormat:@"mm:ss"];
    }
    NSString *newTime = [self.dateFormatter stringFromDate:date];
    return newTime;
}

/** UI改变 */
- (void)changeUIWithStatus:(BSPlayerUIStatus)status
{
    switch (status) {
        case BSPlayerUIStatus_initial:
        {
            self.tapStartView.hidden = NO;
            [self hideHUD];
            self.tapStartBtn.hidden = NO;
            self.actionView.hidden = YES;
        }
            break;
        case BSPlayerUIStatus_prepareToPlay: // 点击了开始播放按钮
        {
            self.tapStartView.hidden = NO;
            [self activeHUD];
            self.tapStartBtn.hidden = YES;
            self.actionView.hidden = YES;
        }
            break;
        case BSPlayerUIStatus_playing:
        {
            self.tapStartView.hidden = NO;
            [self hideHUD];
            self.tapStartBtn.hidden = YES;
            self.actionView.hidden = NO;
        }
            break;
        case BSPlayerUIStatus_loadingBuffer:
        {
            self.tapStartView.hidden = NO;
            [self activeHUD];
            self.tapStartBtn.hidden = YES;
            self.actionView.hidden = NO;
        }
            break;
        case BSPlayerUIStatus_loadFailure:
        {
            self.tapStartView.hidden = NO;
            [self hideHUD];
            self.tapStartBtn.hidden = NO;
            self.actionView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Getter

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;
}

#pragma mark - Observer

static NSString *const kStatus                 = @"status";
static NSString *const kLoadedTimeRanges       = @"loadedTimeRanges";
static NSString *const kPlaybackBufferEmpty    = @"playbackBufferEmpty";
static NSString *const kPlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp";

- (void)addObserverWithPlayerItem:(AVPlayerItem *)item
{
    [item addObserver:self forKeyPath:kStatus options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [item addObserver:self forKeyPath:kLoadedTimeRanges options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [item addObserver:self forKeyPath:kPlaybackBufferEmpty options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [item addObserver:self forKeyPath:kPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserverWithPlayerItem:(AVPlayerItem *)item
{
    [item removeObserver:self forKeyPath:kStatus];
    [item removeObserver:self forKeyPath:kLoadedTimeRanges];
    [item removeObserver:self forKeyPath:kPlaybackBufferEmpty];
    [item removeObserver:self forKeyPath:kPlaybackLikelyToKeepUp];
}

- (void)addNotiObserverWithPlayerItem:(AVPlayerItem *)item
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFininsh) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)removeNotiObserverWithPlayerItem:(AVPlayerItem *)item
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kStatus]) { // 播放状态发生改变
#if DEBUG
        NSLog(@"%ld", (long)self.currentPlayerItem.status);
#endif
        switch (self.currentPlayerItem.status) {
            case AVPlayerItemStatusUnknown:
            {
                [self changeUIWithStatus:BSPlayerUIStatus_initial];
                [self replaceItemWithUrl:self.currentUrl]; // 再次重新创建playerItem
            }
                break;
            case AVPlayerItemStatusReadyToPlay:
            {
                if (self.isAlreadyPlay) {
                    return;
                } else {
                    [self own_play];
                    self.alreadyPlay = YES;
                    [self changeUIWithStatus:BSPlayerUIStatus_playing];
                }
            }
                break;
            case AVPlayerItemStatusFailed:
            {
                [self changeUIWithStatus:BSPlayerUIStatus_initial];
                [self replaceItemWithUrl:self.currentUrl]; // 再次重新创建playerItem
            }
                break;
            default:
                break;
        }
    } else if ([keyPath isEqualToString:kLoadedTimeRanges]) { // 播放缓存
        
    } else if ([keyPath isEqualToString:kPlaybackBufferEmpty]) { // 缓冲是空的时候
#if DEBUG
        NSLog(@"缓冲是空的时候");
#endif
        [self changeUIWithStatus:BSPlayerUIStatus_loadingBuffer];
        if (self.playOrPauseBtn.isSelected) { // 处于暂停状态
            
        } else { // 处于播放状态
            [self.player pause];
        }
    } else if ([keyPath isEqualToString:kPlaybackLikelyToKeepUp]) { // 缓冲好的时候
#if DEBUG
        NSLog(@"缓冲好的时候");
#endif
        [self changeUIWithStatus:BSPlayerUIStatus_playing];
        if (self.playOrPauseBtn.isSelected) { // 处于暂停状态
            
        } else { // 处于播放状态
            [self.player play];
        }
    } else {
        
    }
}

#pragma mark - Public

- (void)replaceItemWithUrl:(NSURL *)url
{
    [self removePlayerTimeObserver];
    [self removeObserverWithPlayerItem:self.currentPlayerItem];
    [self removeNotiObserverWithPlayerItem:self.currentPlayerItem];
    self.currentPlayerItem = [BSPlayerItem playerItemWithURL:url];
    self.currentUrl = url;
    [self addObserverWithPlayerItem:self.currentPlayerItem];
    [self addNotiObserverWithPlayerItem:self.currentPlayerItem];
}

#pragma mark - Action

- (void)startPlay
{
    [self.player replaceCurrentItemWithPlayerItem:self.currentPlayerItem];
    [self changeUIWithStatus:BSPlayerUIStatus_prepareToPlay];
}

- (void)playOrPause
{
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.selected;
    if (self.playOrPauseBtn.isSelected) { // 点击了暂停
        [self own_pause];
        self.continueplayBtn.hidden = NO;
    } else { // 点击了继续播放
        [self own_play];
        self.continueplayBtn.hidden = YES;
    }
}

- (void)fullScreenOrExit
{
    if (self.fullScreenOrExitBtn.isSelected) { // 已经点击了全屏，退出全屏操作
        [self toOrientation:UIInterfaceOrientationPortrait];
    } else {
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

- (CGAffineTransform)getOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        return CGAffineTransformIdentity;
    } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return CGAffineTransformMakeRotation(-M_PI_2);
    } else if(orientation == UIInterfaceOrientationLandscapeRight) {
        return CGAffineTransformMakeRotation(M_PI_2);
    } else {
        return CGAffineTransformIdentity;
    }
}

- (void)playFininsh
{
#if DEBUG
    NSLog(@"playFinish");
#endif
    self.slider.value = 0.0;
    __weak typeof(self) weakSelf = self;
    [self.player seekToTime:CMTimeMakeWithSeconds(self.slider.value * [self playItemDurationTime], self.currentPlayerItem.duration.timescale) completionHandler:^(BOOL finished) {
        [weakSelf playOrPause];
        weakSelf.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [weakSelf convertTime:[weakSelf playItemCurrentTime]], [weakSelf convertTime:[weakSelf playItemDurationTime]]];
    }];
}

/** 框架自带的时间监听器，若没有特殊要求用此方法监听较为合适
 
 - (void)createPlayerTimeObserver
 {
 double duration = self.currentPlayerItem.duration.value / self.currentPlayerItem.duration.timescale;
 __weak typeof(self) weakSelf = self;
 self.timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC) queue:nil usingBlock:^(CMTime time) {
 NSLog(@"*****%lld", time.value / time.timescale);
 weakSelf.slider.value = (time.value / time.timescale) / duration;
 }];
 }
 
 - (void)removePlayerTimeObserver
 {
 if (self.timeObserve) {
 [self.player removeTimeObserver:self.timeObserve];
 self.timeObserve = nil;
 }
 }
 
 */
@end

@implementation BSPlayer (Extension)

- (UIImage *)imageWithColor:(UIColor *)color alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, 30, 30);
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

@end


@implementation BSPlayerItem

- (void)dealloc
{
#if DEBUG
    NSLog(@"%s", __func__);
#endif
}

@end


