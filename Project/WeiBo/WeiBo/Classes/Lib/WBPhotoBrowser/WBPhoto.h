//
//  WBPhoto.h
//  WeiBo
//
//  Created by wbs on 17/2/21.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBPhoto : NSObject

@property (nonatomic, strong) NSString *remoteUrlString; // 大图url
@property (nonatomic, assign) NSInteger index; // 索引
@property (nonatomic, weak) UIImageView *srcView; // 从哪个view上边而来

@end
