//
//  RegistInfo1ViewController.h
//  Sharp Time
//
//  Created by power on 2017/5/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "RegistBaseViewController.h"

@class RegistInfo1ViewController;

@protocol RegistInfo1ViewControllerDelegate <NSObject>

@optional
- (void)registInfo1ViewController:(RegistInfo1ViewController *)registInfo1ViewController didFinishRegistUser:(NSString *)userName;

@end

@interface RegistInfo1ViewController : RegistBaseViewController

@property (nonatomic, weak) id<RegistInfo1ViewControllerDelegate> delegate;

@end
