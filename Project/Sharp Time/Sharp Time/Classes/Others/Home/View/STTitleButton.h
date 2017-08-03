//
//  STTitleButton.h
//  Sharp Time
//
//  Created by power on 2017/5/10.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STTitleButton : UIButton

+ (__kindof STTitleButton *)titleButtonWithConstHeight:(CGFloat)height maxWidth:(CGFloat)maxWidth sideMargin:(CGFloat)sideMargin font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
