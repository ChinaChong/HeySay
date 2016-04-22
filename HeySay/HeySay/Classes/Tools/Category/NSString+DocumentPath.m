//
//  NSString+DocumentPath.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "NSString+DocumentPath.h"

@implementation NSString (DocumentPath)

+ (NSString *)documentPath {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    return path;
}

@end
