//
//  DES3Util.m
//  DES
//
//  Created by Toni on 12-12-27.
//  Copyright (c) 2012年 sinofreely. All rights reserved.
//

#import "DES3Util.h"


#define BuffSize 1024 * 1024 * 2


@implementation DES3Util

//转换1-8的asc码值
const Byte iv[] = "12345678";

//Des加密
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    //开辟堆区空间
    unsigned char *buffer = malloc(BuffSize);
    memset(buffer, 0, sizeof(char));
    @autoreleasepool {
        NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger dataLength = [textData length];
        size_t numBytesEncrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding,
                                              [key UTF8String], kCCKeySizeDES,
                                              iv,
                                              [textData bytes], dataLength,
                                              buffer, BuffSize,
                                              &numBytesEncrypted);
        if (cryptStatus == kCCSuccess) {
            
            NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
            ciphertext = [GTMBase64 stringByEncodingData:data];
            
        }
    }
    //释放堆区空间
    free(buffer);
    return ciphertext;
}

//Des解密
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    unsigned char *buffer = malloc(BuffSize);
    memset(buffer, 0, sizeof(char));
    @autoreleasepool {
        NSData *cipherdata = [GTMBase64 decodeString:cipherText];
        size_t numBytesDecrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                              kCCOptionPKCS7Padding,
                                              [key UTF8String], kCCKeySizeDES,
                                              iv,
                                              [cipherdata bytes], [cipherdata length],
                                              buffer, BuffSize,
                                              &numBytesDecrypted);
        if(cryptStatus == kCCSuccess)
        {            
            NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
            plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
        }
    }
    free(buffer);
    
    return plaintext;
}


@end
