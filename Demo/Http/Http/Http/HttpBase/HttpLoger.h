//
//  HttpLoger.h
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpManager.h"

@interface HttpLoger : NSObject

+ (void)logDebugInfoWithApiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NetMethod)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                   resposeString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error;

@end
