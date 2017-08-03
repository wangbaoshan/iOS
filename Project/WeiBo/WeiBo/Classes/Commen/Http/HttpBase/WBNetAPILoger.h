//
//  WBNetAPILoger.h
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WBNetAPIManager.h"

@interface WBNetAPILoger : NSObject

+ (void)logDebugInfoWithApiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(WBNetMethod)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                   resposeString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

@end
