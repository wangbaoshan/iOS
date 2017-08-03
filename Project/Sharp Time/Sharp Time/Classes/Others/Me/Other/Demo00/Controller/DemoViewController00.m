//
//  DemoViewController00.m
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "DemoViewController00.h"

#import "STCollectionHubView.h"
#import "STCollectionViewCell.h"

static NSString *const cellIdentifier = @"STCollectionViewCell";

@interface DemoViewController00 () <STCollectionHubViewDataSource, STCollectionHubViewDelegate>


@end

@implementation DemoViewController00

- (void)dealloc
{
    STLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [STCollectionHubView setScale:1.5];
    [STCollectionHubView setTopMargin:10];
    STCollectionHubView *hubView = [[STCollectionHubView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 150)];
    [hubView registerClass:[STCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    hubView.dataSource = self;
    hubView.delegate = self;
    [self.view addSubview:hubView];
    
}

#pragma mark - STCollectionHubViewDataSource

- (NSInteger)numberOfItemsInCollectionHubView:(STCollectionHubView *)hubView
{
    return 14;
}

- (STCollectionViewCell *)collectionHubView:(STCollectionHubView *)hubView cellForItemAtIndex:(NSInteger)index
{
    STCollectionViewCell *cell = [hubView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndex:index];
    cell.label.text = [NSString stringWithFormat:@"%ld", index];
    return cell;
}

#pragma mark - STCollectionHubViewDelegate

- (void)collectionHubView:(STCollectionHubView *)hubView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"didSelectItemAtIndex:%ld", index);
}

- (void)collectionHubView:(STCollectionHubView *)hubView didScrollToItemIndex:(NSInteger)index
{
    NSLog(@"didScrollToItemIndex=====%ld", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
