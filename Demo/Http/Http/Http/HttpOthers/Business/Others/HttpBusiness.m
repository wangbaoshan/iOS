//
//  HttpBusiness.m
//  Http
//
//  Created by power on 2017/4/14.
//  Copyright © 2017年 powertorque. All rights reserved.
//  网络接口的业务请求类

#import "HttpBusiness.h"

#import "HttpManager.h"
#import "MJExtension.h"

#import "FetchBannerlistRequest.h"
#import "FetchBannerlistResponse.h"

@implementation HttpBusiness

+ (void)fetchBannerlist:(FetchBannerlistRequest *)request completion:(void (^)(FetchBannerlistResponse *, NSError *))completion
{
    NSMutableDictionary *param = [request mj_keyValues];
    [HttpManager requestWithURL:@"getBannerListByApp.do" parameters:param method:NetMethod_POST timeInterval:15.0f completion:^(id responseObjects, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            FetchBannerlistResponse *bannerResponse = [FetchBannerlistResponse mj_objectWithKeyValues:responseObjects];
            completion(bannerResponse, nil);
        }
    } httpIndexCode:2099];
}

@end
