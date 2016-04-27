//
//  SessionListManager.m
//  HeySay
//
//  Created by ChinaChong on 16/4/27.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "SessionListManager.h"
#import "FMDatabase.h"
#import "NSString+DocumentPath.h"
#import "SessionModel.h"

@implementation SessionListManager

static FMDatabase *database;

+ (instancetype)defaultManeger {
    
    static SessionListManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[SessionListManager alloc] init];
    });
    
    return manager;
}

- (void)openDatabaseWithUserAccount:(NSString *)userAccount {
    
    NSString *path = [[NSString documentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"sessionList_%@.sqlite",userAccount]];
    
    database = [FMDatabase databaseWithPath:path];
    NSLog(@"路径哈哈哈:%@",path);
    [database open];
    
}


- (void)createTable {
    
    if ([database open]) {
        
        if (![self tableExists:database tableName:@"sessionList"]) {
            
            [database executeUpdate:@"CREATE TABLE IF NOT EXISTS sessionList (friendNickName text, friendIconURL text, endTime text, endChatLog text);"];
            
            [database close];
        }
        [database close];
    }
}

- (void)insertSessionWithSessionModel:(SessionModel *)sessionModel {
    
    if ([database open]) {
        
        for (SessionModel *model in [self selectSession]) {
            
            if ([model.friendNickName isEqualToString:sessionModel.friendNickName]) {
                // 更新操作
                [database open];
                NSString *sqlite = [NSString stringWithFormat:@"update sessionList set endTime = '%@' , endChatLog = '%@' where friendNickName = '%@'",sessionModel.endTime,sessionModel.endChatLog,model.friendNickName];
//                NSString *sqliteEndChatLog = [NSString stringWithFormat:@"update sessionList set endChatLog = '%@' where friendNickName = %@",sessionModel.endChatLog,model.friendNickName];
                BOOL update = [database executeUpdate:sqlite];
//                BOOL updateEndChatLog = [database executeUpdate:sqliteEndChatLog];
                NSLog(@"update:%@",(update == 1? @"成功" : @"失败"));
//                NSLog(@"updateEndChatLog:%@",(updateEndChatLog == 1? @"成功" : @"失败"));
                [database close];
                return;
            }
        }
        [database open];
        NSString *sqlite = [NSString stringWithFormat:@"insert into sessionList (friendNickName, friendIconURL, endTime, endChatLog) values ('%@','%@','%@','%@')",sessionModel.friendNickName,sessionModel.friendIconURL,sessionModel.endTime,sessionModel.endChatLog];
        
        BOOL insert = [database executeUpdate:sqlite];
        NSLog(@"insert会话:%@",(insert == 1? @"成功" : @"失败"));
        
        [database close];
    }
}

- (NSMutableArray *)selectSession {
    if ([database open]) {
        
        FMResultSet *resultSet = [database executeQuery:@"select * from sessionList"];
        NSMutableArray *array = [NSMutableArray array];
        while ([resultSet next]) {
            NSString *friendNickName = [resultSet
                                        stringForColumn:@"friendNickName"];
            NSString *friendIconURL  = [resultSet
                                        stringForColumn:@"friendIconURL"];
            NSString *endTime        = [resultSet
                                        stringForColumn:@"endTime"];
            NSString *endChatLog     = [resultSet
                                        stringForColumn:@"endChatLog"];
            SessionModel *model = [[SessionModel alloc] init];
            model.friendNickName = friendNickName;
            model.friendIconURL = friendIconURL;
            model.endTime = endTime;
            model.endChatLog = endChatLog;
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
