//
//  NSString+MD5.h
//  NSStringForMD5
//
//  Created by lanou3g on 16/3/7.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

+ (NSString *)stringByMD5EncryptionWith:(NSString *)string;

@end
