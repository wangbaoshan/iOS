//
//  WBNetAPILoger.m
//  WeiBo
//
//  Created by wbs on 17/2/10.
//  Copyright © 2017年 xiaomaolv. All rights reserved.
//

#import "WBNetAPILoger.h"

@implementation WBNetAPILoger

+ (void)logDebugInfoWithApiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(WBNetMethod)httpMethod
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n",apiName];
    [logString appendFormat:@"Method:\t\t%@\n",[self methodStringWithType:httpMethod]];
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    
    kWBLog(@"%@", logString);
}

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response
                   resposeString:(NSString *)responseString
                         request:(NSURLRequest *)request
                           error:(NSError *)error
{
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n\n"];
    
    [logString appendFormat:@"Status:\t%ld\t(%@)\n\n", (long)response.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode]];
    if (!error) {
        [logString appendFormat:@"Content:\n%@\n\n", responseString];
    }
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendString:@"\n---------------  Related Request Content  --------------\n"];
    
    [logString appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
    [logString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields:@"\t\t\t\t\tN/A"];
    [logString appendFormat:@"\n\nHTTP Body:\n\t%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]];
    
    [logString appendFormat:@"\n\n==============================================================\n=                        Response End                        =\n==============================================================\n\n\n\n"];
    
    kWBLog(@"%@", logString);
}


static NSString *const kWBNetAPILogerMethodString_GET = @"GET";
static NSString *const kWBNetAPILogerMethodString_POST = @"POST";
static NSString *const kWBNetAPILogerMethodString_PUT = @"PUT";
static NSString *const kWBNetAPILogerMethodString_NONE = @"N/A";

+ (NSString *)methodStringWithType:(WBNetMethod)methodType
{
    if (WBNetMethod_GET == methodType) {
        return kWBNetAPILogerMethodString_GET;
    } else if (WBNetMethod_POST == methodType) {
        return kWBNetAPILogerMethodString_POST;
    } else if (WBNetMethod_PUT) {
        return kWBNetAPILogerMethodString_PUT;
    } else {
        return kWBNetAPILogerMethodString_NONE;
    }
}

@end
