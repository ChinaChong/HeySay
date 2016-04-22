//
//  UserModel.h
//  HeySay
//
//  Created by ChinaChong on 16/4/21.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *accountID;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *passWord;
@property (nonatomic,copy) NSString *objectID;
@property (nonatomic,strong) NSMutableArray *friends;
@property (nonatomic,strong) NSMutableArray *chatLog;

@end
