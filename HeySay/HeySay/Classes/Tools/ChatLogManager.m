//
//  ChatLogManager.m
//  HeySay
//
//  Created by ChinaChong on 16/4/26.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "ChatLogManager.h"
#import "FMDatabase.h"
#import "NSString+DocumentPath.h"
#import "ChatLogModel.h"

@implementation ChatLogManager

static FMDatabase *database;

+ (instancetype)defaultManeger {
    
    static ChatLogManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[ChatLogManager alloc] init];
    });
    
    return manager;
}

- (void)openDatabaseWithUserAccount:(NSString *)userAccount {

    NSString *path = [[NSString documentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"chatLog_%@.sqlite",userAccount]];
        
    database = [FMDatabase databaseWithPath:path];
    NSLog(@"路径+++:%@",path);
    [database open];

}


- (void)createTableWithTableName:(NSString *)tableName {
    
    if ([database open]) {
        
        if (![self tableExists:database tableName:[NSString stringWithFormat:@"chatLog_%@",tableName]]) {
            NSString *name = [NSString stringWithFormat:@"chatLog_%@",tableName];
            NSString *sqlite = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (isSend integer, message text);",name];
            
            [database executeUpdate:sqlite];
            
            [database close];
        }
        [database close];
    }
}

- (void)insertChatLogWithChatLogModel:(ChatLogModel *)ChatLogModel withTableName:(NSString *)tableName {
    
    if ([database open]) {
        
        NSString *name = [NSString stringWithFormat:@"chatLog_%@",tableName];
        
        NSString *sqlite = [NSString stringWithFormat:@"insert into %@ (isSend,message) values ('%ld','%@')",name,@(ChatLogModel.isSend).integerValue,ChatLogModel.message];
        
        BOOL insert = [database executeUpdate:sqlite];
        NSLog(@"insert聊天记录:%@",(insert == 1? @"成功" : @"失败"));
        
        [database close];
    }
}

- (NSMutableArray *)selectChatLogWithTableName:(NSString *)tableName {
    if ([database open]) {
        
        NSString *name = [NSString stringWithFormat:@"chatLog_%@",tableName];
        
        NSString *sqlite = [NSString stringWithFormat:@"select * from %@",name];
        
        FMResultSet *resultSet = [database executeQuery:sqlite];
        NSMutableArray *array = [NSMutableArray array];
        while ([resultSet next]) {
            NSInteger flag = [resultSet intForColumn:@"isSend"];
            NSString *message = [resultSet stringForColumn:@"message"];
            ChatLogModel *model = [[ChatLogModel alloc] init];
            model.isSend = (flag == 1? YES : NO);
            model.message = message;
            [array addObject:model];
        }
        [database close];
        return  array;
    }
    
    return nil;
}

- (BOOL)tableExists:(FMDatabase *)db tableName:(NSString *)tableName {
    
    FMResultSet *rs = [database executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}

@end
