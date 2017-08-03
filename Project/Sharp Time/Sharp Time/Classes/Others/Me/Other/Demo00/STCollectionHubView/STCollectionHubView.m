//
//  STCollectionHubView.m
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "STCollectionHubView.h"

#import "STCollectionViewCell.h"
#import "STCollectionViewFlowLayout.h"
#import "STCollectionView.h"

// 颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// 随机色
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

static CGFloat _topMargin = 0;
static CGFloat _scale = 1.3;

@interface STCollectionHubView () <UICollectionViewDelegate, UICollectionViewDataSource, STCollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) STCollectionView *collectionView;

@end

@implementation STCollectionHubView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.collectionView];
    }
    return self;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (STCollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - Setter

+ (void)setTopMargin:(CGFloat)topMargin
{
    _topMargin = topMargin;
}

+ (void)setScale:(CGFloat)scale
{
    // 缩放规则
    if (scale < 1.0) {
        _scale = 1.0;
    } else if (scale > 2.0) {
        _scale = 2.0;
    } else {
        _scale = scale;
    }
}

#pragma mark - Getter

+ (CGFloat)topMargin
{
    return _topMargin;
}

+ (CGFloat)scale
{
    return _scale;
}

- (STCollectionView *)collectionView
{
    if (!_collectionView) {
        STCollectionViewFlowLayout *flowLayout = [[STCollectionViewFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat standard = MIN(self.frame.size.width, self.frame.size.height);
        standard -= _topMargin * 2;
        flowLayout.itemSize = CGSizeMake(standard / _scale, standard / _scale);
        flowLayout.minimumLineSpacing = self.frame.size.height - _topMargin * 2 - flowLayout.itemSize.height;
        CGFloat leftM = self.frame.size.width * 0.5 - flowLayout.itemSize.width * 0.5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, leftM, 0, leftM);
        CGRect rect = CGRectMake(0, _topMargin, self.frame.size.width, self.frame.size.height - _topMargin * 2);
        _collectionView = [[STCollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfItemsInCollectionHubView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource collectionHubView:self cellForItemAtIndex:indexPath.item];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint point = [self convertPoint:collectionView.center toView:collectionView];
    NSIndexPath *pIndexPath = [collectionView indexPathForItemAtPoint:point];
    
    if (pIndexPath.item == indexPath.item) {
        if ([self.delegate respondsToSelector:@selector(collectionHubView:didSelectItemAtIndex:)]) {
            [self.delegate collectionHubView:self didSelectItemAtIndex:indexPath.item];
        }
    } else {
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    }
}

#pragma mark - STCollectionViewFlowLayoutDelegate

- (void)collectionViewFlowLayout:(STCollectionViewFlowLayout *)flowLayout didScrollToItemIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(collectionHubView:didScrollToItemIndex:)]) {
        [self.delegate collectionHubView:self didScrollToItemIndex:index];
    }
}

@end

