//
//  HttpBusiness.h
//  Http
//
//  Created by power on 2017/4/14.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FetchBannerlistRequest;
@class FetchBannerlistResponse;

@interface HttpBusiness : NSObject

+ (void)fetchBannerlist:(FetchBannerlistRequest *)request completion:(void (NS_NOESCAPE ^)(FetchBannerlistResponse *bannerlistResponse, NSError *error))completion;


@end
