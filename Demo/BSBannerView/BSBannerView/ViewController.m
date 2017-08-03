//
//  ViewController.m
//  BSBannerView
//
//  Created by power on 2017/8/1.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "ViewController.h"

#import "BSBannerView.h"

@interface ViewController () <BSBannerViewDelegate>

@property (nonatomic, weak) BSBannerView *bannerView;

@end

@implementation ViewController

- (NSArray<NSString *> *)urls
{
    return @[@"http://47.93.27.170:81/f99d16ed13334d94befe48ff93cc3c25.png",
             @"http://47.93.27.170:81/03b56adde87b468696871a38d695bc1f.png",
             @"http://47.93.27.170:81/e14e32e1c3814c25bace509ff5d981e3.png",
             @"http://47.93.27.170:81/ce927825d8b445a7b78d18481d601189.png",
             @"http://47.93.27.170:81/b03eacb40baf4d0280941828696d04e7.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // bannerView
    BSBannerView *bannerView = [[BSBannerView alloc] init];
    bannerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 180);
    bannerView.delegate = self;
    bannerView.totalPlaceImageView.image = [UIImage imageNamed:@"bannerPlaceholder"];
    bannerView.placeholderImage = [UIImage imageNamed:@"bannerPlaceholder"];
    bannerView.autoScroll = YES;
    [self.view addSubview:bannerView];
    self.bannerView = bannerView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bannerView.imageUrl = [self urls];
    });
}

#pragma mark - BSBannerViewDelegate

- (void)bannerView:(BSBannerView *)bannerView didTapIndex:(NSInteger)index
{
    NSLog(@"tapIndex=====%ld", index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
