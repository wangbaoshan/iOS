//
//  WBReturnDefaultButton.h
//  WeiBo
//
//  Created by wbs on 17/2/7.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBReturnDefaultButton : UIButton

+ (__kindof WBReturnDefaultButton *)returnDefaultButtonWithTarget:(id)target title:(NSString *)title action:(SEL)action;

@end
