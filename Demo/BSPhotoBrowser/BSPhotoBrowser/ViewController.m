//
//  ViewController.m
//  BSPhotoBrowser
//
//  Created by power on 2017/8/1.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "ViewController.h"

#import "UIImageView+WebCache.h"

#import "BSPhotoBrowser.h"
#import "BSPhoto.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<UIImageView *> *imageViews;

@end

@implementation ViewController

- (NSMutableArray<UIImageView *> *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray<NSString *> *urls = [self urls];
    
    CGFloat width = 70;
    CGFloat height = 70;
    CGFloat margin = 5;
    CGFloat startX = (self.view.frame.size.width - 3 * width - 2 * margin) * 0.5;
    CGFloat startY = 100;
    for (int i = 0; i < urls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        int row = i / 3;
        int column = i % 3;
        CGFloat x = startX + column * (width + margin);
        CGFloat y = startY + row * (height + margin);
        imageView.frame = CGRectMake(x, y, width, height);
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:urls[i]] placeholderImage:[UIImage imageNamed:@"placeImage"]];
        
        [self.imageViews addObject:imageView];
        [self.view addSubview:imageView];
    }
}


- (void)tap:(UITapGestureRecognizer *)tapGes
{
    UIImageView *imageView = (UIImageView *)tapGes.view;
    NSArray<NSString *> *urls = [self urls];
    
    // 集成图片浏览器
    NSMutableArray<BSPhoto *> *photos = [NSMutableArray array];
    for (int i = 0; i < urls.count; i++) {
        BSPhoto *photo = [[BSPhoto alloc] init];
        photo.srcView = self.imageViews[i];
        photo.remoteUrlString = urls[i];
        [photos addObject:photo];
    }
    BSPhotoBrowser *browser = [BSPhotoBrowser browserWithPhotos:photos];
    browser.minimumLineSpacing = 10;
    browser.currentIndex = imageView.tag;
    [browser showViewController:self];
}

- (NSArray<NSString *> *)urls
{
    return @[@"http://47.93.27.170:81/f99d16ed13334d94befe48ff93cc3c25.png",
             @"http://47.93.27.170:81/03b56adde87b468696871a38d695bc1f.png",
             @"http://47.93.27.170:81/e14e32e1c3814c25bace509ff5d981e3.png",
             @"http://47.93.27.170:81/ce927825d8b445a7b78d18481d601189.png",
             @"http://47.93.27.170:81/b03eacb40baf4d0280941828696d04e7.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
