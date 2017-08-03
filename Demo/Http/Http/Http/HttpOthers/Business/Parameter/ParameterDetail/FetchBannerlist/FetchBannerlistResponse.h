//
//  FetchBannerlistResponse.h
//  Http
//
//  Created by power on 2017/4/14.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "HttpBaseResponse.h"

@class BannerResult;

@interface FetchBannerlistResponse : HttpBaseResponse

@property (nonatomic, strong) BannerResult *body;

@end
