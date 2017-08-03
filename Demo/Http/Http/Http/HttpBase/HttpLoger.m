//
//  HttpLoger.m
//  Http
//
//  Created by power on 2017/4/7.
//  Copyright © 2017年 powertorque. All rights reserved.
//

#import "HttpLoger.h"

// 打印台日志
#ifdef DEBUG
#define kHttpLog(FORMAT, ...) fprintf(stderr,"[文件:%s, 第%d行] : %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define kHttpLog(FORMAT, ...)
#endif

@implementation HttpLoger

+ (void)logDebugInfoWithApiName:(NSString *)apiName
                  requestParams:(id)requestParams
                     httpMethod:(NetMethod)httpMethod
{
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n",apiName];
    [logString appendFormat:@"Method:\t\t%@\n",[self methodStringWithType:httpMethod]];
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendFormat:@"\n\n**************************************************************\n*                         Request End                        *\n**************************************************************\n\n\n\n"];
    
    kHttpLog(@"%@", logString);
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
    
    kHttpLog(@"%@", logString);
}

static NSString *const kNetAPILogerMethodString_GET = @"GET";
static NSString *const kNetAPILogerMethodString_POST = @"POST";
static NSString *const kNetAPILogerMethodString_PUT = @"PUT";
static NSString *const kNetAPILogerMethodString_NONE = @"N/A";

+ (NSString *)methodStringWithType:(NetMethod)methodType
{
    if (NetMethod_GET == methodType) {
        return kNetAPILogerMethodString_GET;
    } else if (NetMethod_POST == methodType) {
        return kNetAPILogerMethodString_POST;
    } else if (NetMethod_PUT) {
        return kNetAPILogerMethodString_PUT;
    } else {
        return kNetAPILogerMethodString_NONE;
    }
}

@end
