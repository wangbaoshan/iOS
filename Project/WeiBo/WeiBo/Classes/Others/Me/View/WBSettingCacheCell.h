//
//  WBSettingCacheCell.h
//  WeiBo
//
//  Created by wbs on 17/3/13.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBSettingCell.h"

@interface WBSettingCacheCell : WBSettingCell

@property (nonatomic, assign, getter=isCalculating, readonly) BOOL calculating; // 是否正在计算缓存，只读

- (void)clearCache;

@end
