//
//  DatabaseManager.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "DatabaseManager.h"


@implementation DatabaseManager

+ (instancetype)defaultManeger {
    
    static DatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DatabaseManager alloc] init];
    });
    
    return manager;
}



@end
