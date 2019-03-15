//
//  NSData+AES.h
//  Smile
//
//  Created by 蒲晓涛 on 12-11-24.
//  Copyright (c) 2012年 BOX. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#define gIv @"" //可以自行修改

@implementation NSData (Encryption)

#pragma (key和iv向量这里是16位的) 这里是AES128加密CBC加密模式,安全性更高

- (NSData *)AES128EncryptWithKey:(NSString *)key {//加密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES128DecryptWithKey:(NSString *)key {//解密
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCKeySizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [gIv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

#pragma 这里是AES128加密ECB模式

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [GTMBase64 stringByEncodingData:resultData];
    }
    free(buffer);
    return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    return nil;
}


//// 普通字符串转换为十六进
//+ (NSString *)hexStringFromData:(NSData *)data {
//    Byte *bytes = (Byte *)[data bytes];
//    // 下面是Byte 转换为16进制。
//    NSString *hexStr = @"";
//    for(int i=0; i<[data length]; i++) {
//        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
//        newHexStr = [newHexStr uppercaseString];
//        
//        if([newHexStr length] == 1) {
//            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
//        }
//        
//        hexStr = [hexStr stringByAppendingString:newHexStr];
//        
//    }
//    return hexStr;
//}
//
//
////参考：http://blog.csdn.net/linux_zkf/article/details/17124577
////十六进制转Data
//+ (NSData*)dataForHexString:(NSString*)hexString
//{
//    if (hexString == nil) {
//        
//        return nil;
//    }
//    
//    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
//    NSMutableData* data = [NSMutableData data];
//    while (*ch) {
//        if (*ch == ' ') {
//            continue;
//        }
//        char byte = 0;
//        if ('0' <= *ch && *ch <= '9') {
//            
//            byte = *ch - '0';
//        }else if ('a' <= *ch && *ch <= 'f') {
//            
//            byte = *ch - 'a' + 10;
//        }else if ('A' <= *ch && *ch <= 'F') {
//            
//            byte = *ch - 'A' + 10;
//            
//        }
//        
//        ch++;
//        
//        byte = byte << 4;
//        
//        if (*ch) {
//            
//            if ('0' <= *ch && *ch <= '9') {
//                
//                byte += *ch - '0';
//                
//            } else if ('a' <= *ch && *ch <= 'f') {
//                
//                byte += *ch - 'a' + 10;
//                
//            }else if('A' <= *ch && *ch <= 'F'){
//                
//                byte += *ch - 'A' + 10;
//                
//            }
//            
//            ch++;
//            
//        }
//        
//        [data appendBytes:&byte length:1];
//        
//    }
//    
//    return data;
//}



@end
