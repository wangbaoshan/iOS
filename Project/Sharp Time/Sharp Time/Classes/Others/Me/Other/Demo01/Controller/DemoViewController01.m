//
//  DemoViewController01.m
//  Sharp Time
//
//  Created by power on 2017/7/9.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "DemoViewController01.h"

#import "FlowCollectionViewCell.h"
#import "Shop.h"

#import "FlowLayout.h"

#define kReuseIdentifier @"FlowCollectionViewCell"

@interface DemoViewController01 () <UICollectionViewDataSource, UICollectionViewDelegate, FlowLayoutDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<Shop *> *shops;

@end

@implementation DemoViewController01

- (void)dealloc
{
    STLog(@"%s", __func__);
}

- (NSMutableArray<Shop *> *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray arrayWithCapacity:0];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createData];
    
    FlowLayout *layout = [[FlowLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    collectionView.alwaysBounceVertical = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"FlowCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kReuseIdentifier];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

- (void)createData
{
    NSArray<Shop *> *shops = [Shop mj_objectArrayWithFilename:@"shop.plist"];
    [self.shops addObjectsFromArray:shops];
}

#pragma mark - UICollectionViewDataSource

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 2;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FlowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    STLog(@"click-----%@", indexPath);
}

#pragma mark - FlowLayoutDelegate

- (CGFloat)flowLayout:(FlowLayout *)flowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    Shop *shop = self.shops[indexPath.item];
    return itemWidth / shop.w.doubleValue * shop.h.doubleValue;
}

- (NSInteger)numberOfColumnsForFlowLayout:(FlowLayout *)flowLayout
{
    return 3;
}

- (CGFloat)minimumInteritemSpacingForFlowLayout:(FlowLayout *)flowLayout
{
    return 10;
}

- (CGFloat)minimumLineSpacingForFlowLayout:(FlowLayout *)flowLayout
{
    return 10;
}

- (UIEdgeInsets)insetForFlowLayout:(FlowLayout *)flowLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
