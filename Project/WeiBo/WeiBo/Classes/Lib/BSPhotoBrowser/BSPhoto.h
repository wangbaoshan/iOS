//
//  BSPhoto.h
//  WeiBo
//
//  Created by power on 2017/7/31.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSPhoto : NSObject

/// 大图url
@property (nonatomic, strong) NSString *remoteUrlString;
/// 索引
@property (nonatomic, assign) NSInteger index;
/// 从哪个view上边而来
@property (nonatomic, weak) UIImageView *srcView;

@end
