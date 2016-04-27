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
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
        
//        NSString *path = [[NSString documentPath] stringByAppendingPathComponent:@"chatLog.sqlite"];
//        
//        if (![fileManager fileExistsAtPath:path]) {
            [manager createDatabase];
//        }
        
    });
    
    return manager;
}

- (void)createDatabase {
    NSString *path = [[NSString documentPath] stringByAppendingPathComponent:@"chatLog.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    NSLog(@"路径+++:%@",path);
    [database open];
}

- (void)createTableWithTableName:(NSString *)tableName {
    
    if ([database open]) {
        
        if (![self tableExists:database tableName:[NSString stringWithFormat:@"%@_chatLog",tableName]]) {
            
            NSString *sqlite = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@_chatLog (isSend integer, message text);",tableName];
            
            [database executeUpdate:sqlite];
            [database close];
        }
        [database close];
    }
}

- (void)insertChatLogWithChatLogModel:(ChatLogModel *)ChatLogModel withTableName:(NSString *)tableName {
    
    if ([database open]) {
        
        BOOL insert = [database executeUpdateWithFormat:@"insert into %@_chatLog (isSend,message) values (%ld,%@)",tableName,@(ChatLogModel.isSend).integerValue,ChatLogModel.message];
        NSLog(@"insert:%@",(insert == 1? @"成功" : @"失败"));
        
        [database close];
    }
}

- (NSMutableArray *)selectChatLogWithTableName:(NSString *)tableName {
    if ([database open]) {
        
        FMResultSet *resultSet = [database executeQueryWithFormat:@"select * from %@_chatLog",tableName];
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
