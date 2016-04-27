//
//  SessionListManager.h
//  HeySay
//
//  Created by ChinaChong on 16/4/27.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SessionModel;
@interface SessionListManager : NSObject

+ (instancetype)defaultManeger;

- (void)insertSessionWithSessionModel:(SessionModel *)sessionModel;

- (NSMutableArray *)selectSession;

- (void)createTable;

- (void)openDatabaseWithUserAccount:(NSString *)userAccount;

@end
