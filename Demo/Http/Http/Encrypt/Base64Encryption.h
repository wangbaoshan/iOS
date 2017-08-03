//
//  Base64Encryption.h
//  AESEncrypting
//
//  Created by power on 15-5-19.
//  Copyright (c) 2015年 博文卡特. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64Encryption : NSObject
+ (Base64Encryption *)sharedInstance;

-(char)encrypt:(char)b;
-(char)decrypt:(char)b;
+(NSString *)Encryption:(NSString *)encryptionStr;
+(NSString *)Decryption:(NSString *)decryptionStr;
//+(NSDictionary *)EncryptionDic:(NSDictionary *)dic key:(NSArray *)keyArr;

+(NSMutableDictionary *)EncryptionDic:(NSDictionary *)dic key:(NSArray *)keyArr encryptionStr:(NSString *)encryptionStr;

@end
