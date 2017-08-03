//
//  Base64Encryption.m
//  AESEncrypting
//
//  Created by power on 15-5-19.
//  Copyright (c) 2015年 博文卡特. All rights reserved.
//

#import "Base64Encryption.h"
#import "GTMBase64.h"
#import "NSString+AES.h"

@implementation Base64Encryption
+ (Base64Encryption *)sharedInstance
{
    static Base64Encryption *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//线程安全
        sharedInstance = [[Base64Encryption alloc] init];
        
    });
    return sharedInstance;
}

+(NSString *)Encryption:(NSString *)encryptionStr
{
    //base64加密
    NSString *str = [[NSString alloc]initWithString:[GTMBase64 encodeBase64String:encryptionStr]];    
    //转为字符
    const char * a =[str cStringUsingEncoding:NSASCIIStringEncoding];
    
    NSMutableString *encryption = [[NSMutableString alloc]init];
    for (NSInteger i=0; i<str.length;i++ ) {
        char c=(char)[[Base64Encryption sharedInstance]encrypt:a[i]];
        [encryption appendFormat:@"%c",c];
    }
    return encryption;
}


+(NSString *)Decryption:(NSString *)decryptionStr
{

        if (decryptionStr == nil || decryptionStr == NULL || [[decryptionStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        }
        else{
            const char * aa =[decryptionStr cStringUsingEncoding:NSASCIIStringEncoding];
            NSMutableString *decryption = [[NSMutableString alloc]init];
            for (NSInteger i=0; i<decryptionStr.length;i++ ) {
                char c=(char)[[Base64Encryption sharedInstance] decrypt:aa[i]];
                [decryption appendFormat:@"%c",c];
            }
            return     [GTMBase64 decodeBase64String:decryption];
            
        }
    return nil;

}

//+(NSDictionary *)EncryptionDic:(NSDictionary *)dic key:(NSArray *)keyArr;
//{
//    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
////    int i = 0 ;
//    for (NSString *str in keyArr) {
//        NSString *value = [dic objectForKey:str];
//        //自定义加密
////        NSString *enValue = [Base64Encryption Encryption:value];
//        //AES加密
//        NSString *enValue = [value AES256EncryptWithKey:AESKey];
////        i++;
//        [returnDic setObject:enValue forKey:str];
//    }
//    return returnDic;
//}

+ (NSMutableDictionary *)EncryptionDic:(NSDictionary *)dic key:(NSArray *)keyArr encryptionStr:(NSString *)encryptionStr
{
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for (NSString *key in keyArr) {
        NSString *value = [NSString stringWithFormat:@"%@", [dic objectForKey:key]];
        value = [value AES256EncryptWithKey:encryptionStr];
        returnDic[key] = value;
    }
    return returnDic;
}

//加密
-(char)encrypt:(char)b{
    
    static  char UC_ENCRYPT_CHARS[26]  = { 'M', 'D', 'X', 'U', 'P', 'I', 'B', 'E', 'J', 'C', 'T', 'N',
        'K', 'O', 'G', 'W', 'R', 'S', 'F', 'Y', 'V', 'L', 'Z', 'Q', 'A', 'H' };
    
    static  char LC_ENCRYPT_CHARS[26] = { 'm', 'd', 'x', 'u', 'p', 'i', 'b', 'e', 'j', 'c', 't', 'n',
        'k', 'o', 'g', 'w', 'r', 's', 'f', 'y', 'v', 'l', 'z', 'q', 'a', 'h' };
    
    static  char NUM_ENCRYPT_CHARS[10]= {'2','5','0','1','8','6','4','3','7','9'};
    char UC_DECRYPT_CHARS[26];
    char LC_DECRYPT_CHARS[26];
    char NUM_DECRYPT_CHARS[10];
    for (int i = 0; i < 26; i++) {
        char b = UC_ENCRYPT_CHARS[i];
        UC_DECRYPT_CHARS[b - 'A'] = (char) ('A' + i);
        b = LC_ENCRYPT_CHARS[i];
        LC_DECRYPT_CHARS[b - 'a'] = (char) ('a' + i);
    }
    for(int i=0;i<10;i++){
        char b=NUM_ENCRYPT_CHARS[i];
        NUM_DECRYPT_CHARS[b - '0'] = (char)('0' + i);
    }
    if (b >= 'A' && b <= 'Z') {
        char a = UC_ENCRYPT_CHARS[b - 'A'];
        return a;
    } else if (b >= 'a' && b <= 'z') {
        return LC_ENCRYPT_CHARS[b - 'a'];
    } else if(b>='0' && b<='9'){
        return NUM_ENCRYPT_CHARS[b - '0'];
    }else if(b=='+'){
        return '#';
    }else if(b=='/'){
        return '$';
    }else if(b=='='){
        return '%';
    }else{
        return b;
    }
    
}
//解密
-(char)decrypt:(char)b{
    
    static  char UC_ENCRYPT_CHARS[26]  = { 'M', 'D', 'X', 'U', 'P', 'I', 'B', 'E', 'J', 'C', 'T', 'N',
        'K', 'O', 'G', 'W', 'R', 'S', 'F', 'Y', 'V', 'L', 'Z', 'Q', 'A', 'H' };
    
    static  char LC_ENCRYPT_CHARS[26] = { 'm', 'd', 'x', 'u', 'p', 'i', 'b', 'e', 'j', 'c', 't', 'n',
        'k', 'o', 'g', 'w', 'r', 's', 'f', 'y', 'v', 'l', 'z', 'q', 'a', 'h' };
    
    static  char NUM_ENCRYPT_CHARS[10]= {'2','5','0','1','8','6','4','3','7','9'};
    char UC_DECRYPT_CHARS[26];
    char LC_DECRYPT_CHARS[26];
    char NUM_DECRYPT_CHARS[10];
    for (int i = 0; i < 26; i++) {
        char b = UC_ENCRYPT_CHARS[i];
        UC_DECRYPT_CHARS[b - 'A'] = (char) ('A' + i);
        b = LC_ENCRYPT_CHARS[i];
        LC_DECRYPT_CHARS[b - 'a'] = (char) ('a' + i);
    }
    for(int i=0;i<10;i++){
        char b=NUM_ENCRYPT_CHARS[i];
        NUM_DECRYPT_CHARS[b - '0'] = (char)('0' + i);
    }
    if (b >= 'A' && b <= 'Z') {
        return UC_DECRYPT_CHARS[b - 'A'];
    } else if (b >= 'a' && b <= 'z') {
        return LC_DECRYPT_CHARS[b - 'a'];
    } else if(b>='0' && b<='9'){
        return NUM_DECRYPT_CHARS[b - '0'];
    }else if(b=='#'){
        return '+';
    }else if(b=='$'){
        return '/';
    }else if(b=='%'){
        return '=';
    }else{
        return b;
    }
}

@end
