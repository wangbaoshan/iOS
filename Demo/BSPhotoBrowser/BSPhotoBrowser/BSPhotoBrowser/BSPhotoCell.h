//
//  BSPhotoCell.h
//  WeiBo
//
//  Created by power on 2017/7/30.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSPhoto;
@class BSPhotoCell;
@class BSPhotoBrowserHUD;

@protocol BSPhotoCellDelegate <NSObject>

@optional
- (void)photoCellDidSingleTap:(BSPhotoCell *)detailCell;

@end

@interface BSPhotoCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) UIImageView *imageView;
@property (nonatomic, weak, readonly) BSPhotoBrowserHUD *hud;

@property (nonatomic, strong) BSPhoto *photo;
@property (nonatomic, weak) id<BSPhotoCellDelegate> delegate;

@end

