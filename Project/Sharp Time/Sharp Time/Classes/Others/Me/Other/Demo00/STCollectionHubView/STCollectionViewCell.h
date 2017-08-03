//
//  STCollectionViewCell.h
//  Sharp Time
//
//  Created by power on 2017/6/12.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UILabel *label;

/// 设置字体需处理一下
- (CGFloat)textFontSize:(CGFloat)fontSize;

@end
