//
//  SessionModel.h
//  HeySay
//
//  Created by ChinaChong on 16/4/26.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionModel : NSObject

@property (nonatomic,copy) NSString *friendNickName;
@property (nonatomic,copy) NSString *friendIconURL;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *endChatLog;

@end
