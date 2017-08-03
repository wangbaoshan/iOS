//
//  FlowCollectionViewCell.m
//  Sharp Time
//
//  Created by power on 2017/7/15.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "FlowCollectionViewCell.h"

#import "Shop.h"

@implementation FlowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:nil];
}

@end
