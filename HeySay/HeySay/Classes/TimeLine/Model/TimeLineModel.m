//
//  TimeLineModel.m
//  Gossip
//
//  Created by lanou3g on 16/4/19.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "TimeLineModel.h"

@implementation TimeLineModel

-(id)initWithDict:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+(id)TimeLineModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
