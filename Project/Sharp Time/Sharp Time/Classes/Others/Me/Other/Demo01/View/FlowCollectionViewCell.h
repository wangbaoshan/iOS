//
//  FlowCollectionViewCell.h
//  Sharp Time
//
//  Created by power on 2017/7/15.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Shop;

@interface FlowCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) Shop *shop;

@end
