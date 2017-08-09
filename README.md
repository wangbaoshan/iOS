# iOS
## Demo／BSBannerView  图片轮播器
### 应用两个UIImageView无缝展示多张图片
#### 集成方法： 
#### BSBannerView *bannerView = [[BSBannerView alloc] init];
#### bannerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 180);
#### bannerView.delegate = self;
#### bannerView.totalPlaceImageView.image = [UIImage imageNamed:@"bannerPlaceholder"];
#### bannerView.placeholderImage = [UIImage imageNamed:@"bannerPlaceholder"];
#### bannerView.autoScroll = YES; 
#### [self.view addSubview:bannerView];

#### bannerView.imageUrl = [self urls]; // 设置Url数组，会重新刷新控件的图片

#### 代理方法-点击了哪一张图片
#### - (void)bannerView:(BSBannerView *)bannerView didTapIndex:(NSInteger)index
#### {
####    NSLog(@"tapIndex=====%ld", index);
#### }
