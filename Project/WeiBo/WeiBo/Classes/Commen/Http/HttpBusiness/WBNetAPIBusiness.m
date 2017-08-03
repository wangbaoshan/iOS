//
//  WBNetAPIBusiness.m
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBNetAPIBusiness.h"

#import "WBNetAPIManager.h"
#import "WBHomeStatusesResult.h"
#import "WBUserContentParamter.h"
#import "WBUserContentResult.h"

@implementation WBNetAPIBusiness

+ (void)currentUserContent:(WBUserContentParamter *)paramter completion:(void (^)(WBUserContentResult *, NSError *))completion
{
    NSMutableDictionary *para = [paramter mj_keyValues];
    [WBNetAPIManager requestWithURL:kCurrentUserContentUrlString parameters:para method:WBNetMethod_GET completion:^(id responseObjects, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        } else {
            if (completion) {
                WBUserContentResult *userResult = [WBUserContentResult mj_objectWithKeyValues:responseObjects];
                completion(userResult, nil);
            }
        }
    }];
    
}

+ (void)homeStatuses:(WBHomeStatusesResult *)paramter completion:(void (^)(WBHomeStatusesResult *, NSError *))completion
{
    NSMutableDictionary *para = [paramter mj_keyValues];
    [WBNetAPIManager requestWithURL:kCurrentUserWeiBoUrlString parameters:para method:WBNetMethod_GET completion:^(id responseObjects, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil, error);
            }
        } else {
            if (completion) {
                WBHomeStatusesResult *homeResult = [WBHomeStatusesResult mj_objectWithKeyValues:responseObjects];
                completion(homeResult, nil);
            }
        }
    }];
}

@end
