//
//  BSPhotoBrowser.m
//  WeiBo
//
//  Created by power on 2017/7/30.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "BSPhotoBrowser.h"

#import "UIImageView+WebCache.h"

#import "BSPhotoCell.h"
#import "BSPhoto.h"

#define kAnimationDuringTimeInterval 0.35f
static NSString *cellID = @"cellID";

@interface BSPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, BSPhotoCellDelegate>

@property (nonatomic, strong) NSArray<BSPhoto *> *photos;
@property (nonatomic, strong) UIImageView *placeView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UILabel *pageLabel;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign, getter=isNeedHideStatusBar) BOOL needHideStatusBar;

@end

@implementation BSPhotoBrowser

+ (BSPhotoBrowser *)browserWithPhotos:(NSArray<BSPhoto *> *)photos
{
    return [[self alloc] initWithPhotos:photos];
}

- (BSPhotoBrowser *)initWithPhotos:(NSArray<BSPhoto *> *)photos
{
    self = [super init];
    if (self) {
        self.photos = photos;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalPresentationCapturesStatusBarAppearance = YES;
    }
    return self;
}

- (instancetype)init
{
    NSAssert(NO, @"Please use browserWithPhotos: instead");
    return nil;
}

- (void)showViewController:(UIViewController *)vc
{
    [vc presentViewController:self animated:NO completion:nil];
}

- (void)dismiss
{
    self.needHideStatusBar = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.photos[self.startIndex].srcView.hidden = NO;
        
        BSPhoto *photo = self.photos[self.currentIndex];
        UIImageView *srcView = photo.srcView;
        
        CGRect placeRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
        if (srcView.image) { // 原视图加载出图片
            placeRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / srcView.image.size.width * srcView.image.size.height);
        }
        self.placeView.bounds = placeRect;
        self.placeView.center = self.view.center;
        
        // 坐标转换
        CGRect newFrame = [self.view convertRect:srcView.frame fromView:srcView.superview];
        self.placeView.image = srcView.image;
        [self.view addSubview:self.placeView];
        
        // 动画
        self.collectionView.hidden = YES;
        self.pageLabel.hidden = YES;
        srcView.hidden = YES;
        self.view.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:kAnimationDuringTimeInterval animations:^{
            self.placeView.frame = newFrame;
        } completion:^(BOOL finished) {
            srcView.hidden = NO;
            self.placeView = nil;
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    });
    
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor blackColor];
    
    // collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    layout.minimumLineSpacing = self.minimumLineSpacing;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, self.minimumLineSpacing);;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGRect frame = self.view.bounds;
    frame.size.width += self.minimumLineSpacing;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[BSPhotoCell class] forCellWithReuseIdentifier:cellID];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.hidden = YES;
    
    // pageLabel
    UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - 100) * 0.5, 20, 100, 30)];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    pageLabel.textColor = [UIColor whiteColor];
    pageLabel.font = [UIFont boldSystemFontOfSize:19];
    [self.view addSubview:pageLabel];
    self.pageLabel = pageLabel;
    self.pageLabel.hidden = YES;
    
    // 显示当前页码
    self.currentIndex = self.currentIndex;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self show];
}

#pragma mark - Setter

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex > self.photos.count - 1) {
        _currentIndex = self.photos.count - 1;
    } else {
        _currentIndex = currentIndex;
    }
    
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex + 1, self.photos.count];
}


#pragma mark - Getter

/// placeView用于展示缩放动画，懒加载方式创建
- (UIImageView *)placeView
{
    if (_placeView == nil) {
        _placeView = [[UIImageView alloc] init];
        _placeView.contentMode = UIViewContentModeScaleAspectFill;
        _placeView.clipsToBounds = YES;
    }
    return _placeView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.photo = self.photos[indexPath.item];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (NSInteger)((scrollView.contentOffset.x + self.collectionView.bounds.size.width * 0.5) / self.collectionView.bounds.size.width);
}

#pragma mark - BSPhotoCellDelegate

- (void)photoCellDidSingleTap:(BSPhotoCell *)detailCell
{
    [self dismiss];
}


#pragma mark - Private

- (void)show
{
    self.needHideStatusBar = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 记录初始index
        self.startIndex = self.currentIndex;
        
        // 先滚到相应位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.startIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        
        BSPhoto *photo = self.photos[self.startIndex];
        UIImageView *srcView = photo.srcView;
        
        CGRect placeRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
        if (srcView.image) { // 原视图加载出图片
            placeRect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width / srcView.image.size.width * srcView.image.size.height);
        }
        
        // 坐标转换
        CGRect newFrame = [srcView.superview convertRect:srcView.frame toView:self.view];
        if (self.needHideStatusBar) {
            newFrame.origin.y += 20;
        }
        self.placeView.frame = newFrame;
        [self.view addSubview:self.placeView];
        [self.placeView sd_setImageWithURL:[NSURL URLWithString:photo.remoteUrlString] placeholderImage:srcView.image];
        
        // 动画呈现
        srcView.hidden = YES;
        [UIView animateWithDuration:kAnimationDuringTimeInterval animations:^{
            CGFloat h = placeRect.size.height;
            if (h > self.view.bounds.size.height) {
                self.placeView.frame = CGRectMake(0, 0, self.view.bounds.size.width, placeRect.size.height);
            } else {
                self.placeView.bounds = placeRect;
                self.placeView.center = self.view.center;
            }
        } completion:^(BOOL finished) {
            [self.placeView removeFromSuperview];
            self.collectionView.hidden = NO;
            self.pageLabel.hidden = NO;
        }];
    });
    
}

- (BOOL)prefersStatusBarHidden
{
    if (self.isNeedHideStatusBar) {
        return YES;
    } else {
        return NO;
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

@end
