//
//  WBPhotoDetailCell.h
//  WeiBo
//
//  Created by wbs on 17/2/24.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WBPhoto;
@class WBPhotoDetailCell;

@protocol WBPhotoDetailCellDelegate <NSObject>

@optional
- (void)photoDetailCellDidSingleTap:(WBPhotoDetailCell *)detailCell;

@end

@interface WBPhotoDetailCell : UICollectionViewCell

@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, weak, readonly) UIImageView *imageView;

@property (nonatomic, strong) WBPhoto *photo;
@property (nonatomic, weak) id<WBPhotoDetailCellDelegate> delegate;

@end
