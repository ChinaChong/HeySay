//
//  NSString+MD5.m
//  NSStringForMD5
//
//  Created by lanou3g on 16/3/7.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonCrypto.h>
@implementation NSString (MD5)

+ (NSString *)stringByMD5EncryptionWith:(NSString *)string {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    // 第一个参数需要转成C语言字符串
    CC_MD5([string UTF8String], (CC_LONG)string.length, result);
    NSMutableString *mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i = 0; i < 16; i++) {
        [mstr appendFormat:@"%02X",result[i]];
    }
    return mstr;
}

@end
