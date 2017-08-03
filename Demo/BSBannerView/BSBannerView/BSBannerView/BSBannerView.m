//
//  BSBannerView.m
//  BSBannerView
//
//  Created by bs on 16/9/7.
//  Copyright © 2016年 onairm. All rights reserved.
//

#import "BSBannerView.h"
#import "UIImageView+WebCache.h"

#define kScrollEnableAtleastCount  3
#define kTransitionDuringTime      0.3f
#define kDefaultScrollSeparateTime 3.0f

@interface BSBannerView () <UIScrollViewDelegate> {
    NSInteger _currentIndex;
}

@property (nonatomic, strong) UIScrollView *subScrollView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *otherImageView;
@property (nonatomic, strong) UIImageView *totalPlaceImageView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSArray *currentImages;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) CATransition *transition;

@end

@implementation BSBannerView

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%s", __func__);
#endif
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupSubViews];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
}

#pragma mark - Init

+ (BSBannerView *)bannerView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadSubViews];
        
    }
    return self;
}

- (BSBannerView *)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageArray = imageArray;
        
        [self loadSubViews];
        
    }
    return self;
}

- (BSBannerView *)initWithFrame:(CGRect)frame imageUrl:(NSArray<NSString *> *)imageUrl
{
    if (self = [super initWithFrame:frame]) {
        
        self.imageUrl = imageUrl;
        
        [self loadSubViews];
        
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self loadSubViews];
        
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX > scrollView.bounds.size.width) { // right slide
        NSInteger index = [self nextCorrectIndex];
        [self otherImageViewLoadImage:index];
        self.otherImageView.frame = CGRectMake(CGRectGetMaxX(self.currentImageView.frame), 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
        if (offsetX == scrollView.bounds.size.width * 2) {
            self.currentIndex ++;
            self.currentImageView.image = self.otherImageView.image;
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
    } else if (offsetX < scrollView.bounds.size.width) { // left slide
        NSInteger index = [self lastCorrectIndex];
        [self otherImageViewLoadImage:index];
        self.otherImageView.frame = CGRectMake(0, 0, scrollView.bounds.size.width, scrollView.bounds.size.height);
        if (offsetX == 0) {
            self.currentIndex --;
            self.currentImageView.image = self.otherImageView.image;
            scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        }
    } else {
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.currentIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoScroll) {
        [self removeTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isAutoScroll) {
        [self addTimer];
    }
}

- (void)invalidate
{
    [self removeTimer];
}

#pragma mark - Private

- (void)loadSubViews
{
    [self.subScrollView addSubview:self.currentImageView];
    [self.subScrollView addSubview:self.otherImageView];
    [self addSubview:self.totalPlaceImageView];
    [self addSubview:self.subScrollView];
    [self addSubview:self.pageControl];
}

- (void)setupSubViews
{
    self.totalPlaceImageView.frame = self.bounds;
    self.subScrollView.frame = self.bounds;
    self.subScrollView.contentSize = CGSizeMake(self.bounds.size.width * kScrollEnableAtleastCount, self.bounds.size.height);
    self.subScrollView.contentOffset = CGPointMake(self.subScrollView.bounds.size.width, 0);
    self.currentImageView.frame = CGRectMake(self.subScrollView.bounds.size.width, 0, self.subScrollView.bounds.size.width, self.subScrollView.bounds.size.height);
    [self currentImageViewLoadImage:self.currentIndex];
    
    self.pageControl.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.95);
}

- (void)setupPageControl:(NSInteger)count
{
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:count];
    self.pageControl.bounds = (CGRect){{0, 0}, pageSize};
    self.pageControl.numberOfPages = count;
}

- (void)addTimer
{
    if (self.timer) return;
    NSTimeInterval timeInterval = kDefaultScrollSeparateTime;
    if (self.scrollSeparateTime > 0.0) {
        timeInterval = self.scrollSeparateTime;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(turnPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    if (!self.timer) return;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)currentImageViewLoadImage:(NSInteger)index
{
    if (_photosType == BSBannerViewPhotosTypeRemote) {
        if (self.currentImages.count == 0) {
            return;
        }else
            [self.currentImageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[self.currentIndex]] placeholderImage:self.placeholderImage];
    } else if (_photosType == BSBannerViewPhotosTypeLocal) {
        self.currentImageView.image = self.currentImages[index];
    } else {
        
    }
}

- (void)otherImageViewLoadImage:(NSInteger)index
{
    if (_photosType == BSBannerViewPhotosTypeRemote) {
        [self.otherImageView sd_setImageWithURL:[NSURL URLWithString:self.currentImages[index]] placeholderImage:self.placeholderImage];
    } else if (_photosType == BSBannerViewPhotosTypeLocal) {
        self.otherImageView.image = self.currentImages[index];
    } else {
        
    }
}

- (NSInteger)nextCorrectIndex
{
    NSInteger index = self.currentIndex + 1;
    if (index < 0) {
        index = self.currentImages.count - 1;
    } else if (index >= self.currentImages.count) {
        index = 0;
    }
    return index;
}

- (NSInteger)lastCorrectIndex
{
    NSInteger index = self.currentIndex - 1;
    if (index < 0) {
        index = self.currentImages.count - 1;
    } else if (index >= self.currentImages.count) {
        index = 0;
    }
    return index;
}


#pragma mark - Setter

- (void)setImageArray:(NSArray<UIImage *> *)imageArray
{
    _imageArray = imageArray;
    
    self.currentImages = imageArray;
    _photosType = BSBannerViewPhotosTypeLocal;
    
    if (imageArray.count > 1) {
        self.subScrollView.scrollEnabled = YES;
        if (self.isAutoScroll) {
            [self addTimer];
        }
    } else {
        self.subScrollView.scrollEnabled = NO;
    }
    
    [self setupPageControl:imageArray.count];
}

- (void)setImageUrl:(NSArray<NSString *> *)imageUrl
{
    _imageUrl = imageUrl;
    
    self.currentImages = imageUrl;
    _photosType = BSBannerViewPhotosTypeRemote;
    
    if (imageUrl.count > 1) {
        self.subScrollView.scrollEnabled = YES;
        if (self.autoScroll) {
            [self addTimer];
        }
    } else {
        self.subScrollView.scrollEnabled = NO;
    }
    
    [self setupPageControl:imageUrl.count];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    if (_currentIndex < 0) {
        _currentIndex = self.currentImages.count - 1;
    } else if (_currentIndex >= self.currentImages.count) {
        _currentIndex = 0;
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        if (_photosType == BSBannerViewPhotosTypeRemote) {
            if (self.imageUrl.count > 1) {
                [self addTimer];
            }
        } else if (_photosType == BSBannerViewPhotosTypeLocal) {
            if (self.imageArray.count > 1) {
                [self addTimer];
            }
        } else {
            
        }
    } else {
        [self removeTimer];
    }
    
}

#pragma mark - Getter

- (NSInteger)currentIndex
{
    if (_currentIndex < 0) {
        _currentIndex = self.currentImages.count - 1;
    } else if (_currentIndex >= self.currentImages.count) {
        _currentIndex = 0;
    }
    return _currentIndex;
}

- (UIScrollView *)subScrollView
{
    if (_subScrollView == nil) {
        _subScrollView = [[UIScrollView alloc] init];
        _subScrollView.pagingEnabled = YES;
        _subScrollView.bounces = NO;
        _subScrollView.showsVerticalScrollIndicator = NO;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        _subScrollView.delegate = self;
        [_subScrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return _subScrollView;
}

- (UIImageView *)currentImageView
{
    if (_currentImageView == nil) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.userInteractionEnabled = YES;
        _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
        _currentImageView.clipsToBounds = YES;
    }
    return _currentImageView;
}

- (UIImageView *)otherImageView
{
    if (_otherImageView == nil) {
        _otherImageView = [[UIImageView alloc] init];
        _otherImageView.userInteractionEnabled = YES;
        _otherImageView.contentMode = UIViewContentModeScaleAspectFill;
        _otherImageView.clipsToBounds = YES;
    }
    return _otherImageView;
}

- (UIImageView *)totalPlaceImageView
{
    if (_totalPlaceImageView == nil) {
        _totalPlaceImageView = [[UIImageView alloc] init];
        _totalPlaceImageView.userInteractionEnabled = YES;
        _totalPlaceImageView.contentMode = UIViewContentModeScaleAspectFill;
        _totalPlaceImageView.clipsToBounds = YES;
    }
    return _totalPlaceImageView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.3];
    }
    return _pageControl;
}

- (CATransition *)transition
{
    if (_transition == nil) {
        _transition = [CATransition animation];
        _transition.duration = kTransitionDuringTime;
        _transition.type = @"push";
        _transition.subtype = kCATransitionFromRight;
    }
    return _transition;
}

#pragma mark - Action

- (void)tap:(UITapGestureRecognizer *)tapGes
{
    if (self.imageUrl.count == 0 && self.imageArray.count == 0) return;
    if ([self.delegate respondsToSelector:@selector(bannerView:didTapIndex:)]) {
        [self.delegate bannerView:self didTapIndex:self.currentIndex];
    }
}

- (void)turnPage
{
    [self.subScrollView.layer addAnimation:self.transition forKey:nil];
    
    self.currentIndex ++;
    [self currentImageViewLoadImage:self.currentIndex];
    
    [UIView animateWithDuration:kTransitionDuringTime animations:^{
        self.pageControl.currentPage = self.currentIndex;
    }];
}

@end

