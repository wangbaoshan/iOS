# iOS
## Demo／BSBannerView  图片轮播器
### 应用两个UIImageView无缝展示多张图片
#### 集成方法 
#### BSBannerView *bannerView = [[BSBannerView alloc] init];
#### bannerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 180);
#### bannerView.delegate = self;
#### bannerView.totalPlaceImageView.image = [UIImage imageNamed:@"bannerPlaceholder"];
#### bannerView.placeholderImage = [UIImage imageNamed:@"bannerPlaceholder"];
#### bannerView.autoScroll = YES; 
#### [self.view addSubview:bannerView];
#### bannerView.imageUrl = [self urls]; // 设置Url数组，会重新刷新控件的图片

#### 代理方法（点击了哪一张图片）
#### - (void)bannerView:(BSBannerView *)bannerView didTapIndex:(NSInteger)index
#### {
####    NSLog(@"tapIndex=====%ld", index);
#### }


## Demo / BSPhotoBrowser
### 集成图片浏览器，仿照新浪微博的点击看大图效果
#### 集成方法
#### - (void)tap:(UITapGestureRecognizer *)tapGes
#### {
#### UIImageView *imageView = (UIImageView *)tapGes.view;
#### NSArray<NSString *> *urls = [self urls];  
#### // 集成图片浏览器
#### NSMutableArray<BSPhoto *> *photos = [NSMutableArray array];
#### for (int i = 0; i < urls.count; i++) {
####    BSPhoto *photo = [[BSPhoto alloc] init];
####    photo.srcView = self.imageViews[i];
####    photo.remoteUrlString = urls[i];
####    [photos addObject:photo];
#### }
#### BSPhotoBrowser *browser = [BSPhotoBrowser browserWithPhotos:photos];
#### browser.minimumLineSpacing = 10;
#### browser.currentIndex = imageView.tag;
#### [browser showViewController:self];
#### }


