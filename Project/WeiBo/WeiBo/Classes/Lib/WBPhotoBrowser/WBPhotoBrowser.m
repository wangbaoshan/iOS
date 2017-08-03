//
//  WBPhotoBrowser.m
//  WeiBo
//
//  Created by wbs on 17/2/21.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBPhotoBrowser.h"

#import "WBPhotoDetailCell.h"
#import "WBPhoto.h"

NSString *const kWBPhotoBrowserShouldHideStatusBar = @"kWBPhotoBrowserShouldHideStatusBar";
NSString *const kWBPhotoBrowserShouldNotHideStatusBar = @"kWBPhotoBrowserShouldNotHideStatusBar";

#define kAnimationDuringTimeInterval 0.25f
static NSString *cellID = @"cellID";

@interface WBPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, WBPhotoDetailCellDelegate>

@property (nonatomic, strong) UIImageView *placeView;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger startIndex;
@property (nonatomic, weak) UILabel *pageLabel;

@end

@implementation WBPhotoBrowser

- (void)dealloc
{
    NSLog(@"WBPhotoBrowser-----dealloc");
}

+ (WBPhotoBrowser *)browser
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = [UIApplication sharedApplication].keyWindow.bounds;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGRect frame = self.bounds;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[WBPhotoDetailCell class] forCellWithReuseIdentifier:cellID];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        self.collectionView.hidden = YES;
        
        UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - 100) * 0.5, 20, 100, 30)];
        pageLabel.textAlignment = NSTextAlignmentCenter;
        pageLabel.textColor = [UIColor whiteColor];
        pageLabel.font = [UIFont boldSystemFontOfSize:19];
        [self addSubview:pageLabel];
        self.pageLabel = pageLabel;
        self.pageLabel.hidden = YES;
    }
    return self;
}

- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing
{
    _minimumLineSpacing = minimumLineSpacing;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGRect frame = self.collectionView.frame;
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, minimumLineSpacing);
    frame.size.width += minimumLineSpacing;
    self.collectionView.frame = frame;
    self.collectionView.collectionViewLayout = layout;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentIndex = (NSInteger)((scrollView.contentOffset.x + self.collectionView.bounds.size.width * 0.5) / self.collectionView.bounds.size.width);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBPhotoDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.photo = self.photos[indexPath.item];
    return cell;
}

- (void)setPhotos:(NSArray<WBPhoto *> *)photos
{
    _photos = photos;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex > self.photos.count - 1) {
        _currentIndex = self.photos.count - 1;
    } else {
        _currentIndex = currentIndex;
    }
    
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", _currentIndex + 1, self.photos.count];
}

- (UIImageView *)placeView
{
    if (_placeView == nil) {
        _placeView = [[UIImageView alloc] init];
        _placeView.contentMode = UIViewContentModeScaleAspectFit;
        _placeView.clipsToBounds = YES;
    }
    return _placeView;
}

- (void)show
{
    // 应该隐藏状态栏
    [[NSNotificationCenter defaultCenter] postNotificationName:kWBPhotoBrowserShouldHideStatusBar object:nil];
    
    // 记录初始index
    self.startIndex = self.currentIndex;
    
    // 先滚到相应位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.startIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    WBPhoto *photo = self.photos[self.startIndex];
    UIImageView *srcView = photo.srcView;
    // 算出图片真实的宽高
    CGRect placeRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width / srcView.bounds.size.width * srcView.bounds.size.height);
    if (srcView.image.size.width != 0.0) { // 原视图加载出图片
        placeRect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width / srcView.image.size.width * srcView.image.size.height);
    }
    
    // 坐标转换
    CGRect newFrame = [srcView.superview convertRect:srcView.frame toView:self];
    self.placeView.frame = newFrame;
    [self.placeView sd_setImageWithURL:[NSURL URLWithString:photo.remoteUrlString] placeholderImage:srcView.image];
    [self addSubview:self.placeView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    // 假象+动画
    srcView.hidden = YES;
    self.backgroundColor = [UIColor blackColor];
    [UIView animateWithDuration:kAnimationDuringTimeInterval animations:^{
        CGFloat h = placeRect.size.height;
        if (h > self.bounds.size.height) {
            self.placeView.frame = CGRectMake(0, 0, self.bounds.size.width, placeRect.size.height);
        } else {
            self.placeView.bounds = placeRect;
            self.placeView.center = self.center;
        }
        
    } completion:^(BOOL finished) {
        [self.placeView removeFromSuperview];
        self.collectionView.hidden = NO;
        self.pageLabel.hidden = NO;
    }];
    
}


- (void)dismiss
{
    // 应该显示状态栏
    [[NSNotificationCenter defaultCenter] postNotificationName:kWBPhotoBrowserShouldNotHideStatusBar object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.photos[self.startIndex].srcView.hidden = NO;
        
        WBPhoto *photo = self.photos[self.currentIndex];
        UIImageView *srcView = photo.srcView;
        
        // 坐标转换
        CGRect newFrame = [self convertRect:srcView.frame fromView:srcView.superview];
        self.placeView.image = srcView.image;
        [self addSubview:self.placeView];
        
        // 假象+动画
        self.collectionView.hidden = YES;
        self.pageLabel.hidden = YES;
        srcView.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        
        [UIView animateWithDuration:kAnimationDuringTimeInterval animations:^{
            self.placeView.frame = newFrame;
        } completion:^(BOOL finished) {
            srcView.hidden = NO;
            [self removeFromSuperview];
            self.placeView = nil;
        }];
    });
}

#pragma mark - WBPhotoDetailCellDelegate

- (void)photoDetailCellDidSingleTap:(WBPhotoDetailCell *)detailCell
{
    [self dismiss];
}

@end
