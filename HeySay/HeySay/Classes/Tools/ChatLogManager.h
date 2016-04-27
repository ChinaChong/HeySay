//
//  ChatLogManager.h
//  HeySay
//
//  Created by ChinaChong on 16/4/26.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChatLogModel;
@interface ChatLogManager : NSObject

+ (instancetype)defaultManeger;

- (void)insertChatLogWithChatLogModel:(ChatLogModel *)ChatLogModel withTableName:(NSString *)tableName;

- (NSMutableArray *)selectChatLogWithTableName:(NSString *)tableName;

- (void)createTableWithTableName:(NSString *)tableName;

- (void)openDatabaseWithUserAccount:(NSString *)userAccount;

@end
