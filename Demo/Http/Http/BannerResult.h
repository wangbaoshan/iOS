//
//  BannerResult.h
//  Http
//
//  Created by power on 2017/4/14.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Banner;

@interface BannerResult : NSObject

@property (nonatomic, copy) NSArray<Banner *> *bannerList;

@end

@interface Banner : NSObject

@property (nonatomic, copy) NSString *bannerUrl;

@end
