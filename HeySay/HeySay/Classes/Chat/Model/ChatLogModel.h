//
//  ChatLogModel.h
//  HeySay
//
//  Created by ChinaChong on 16/4/26.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatLogModel : NSObject

@property (nonatomic,assign) BOOL     isSend;
@property (nonatomic,copy)   NSString *message;

@end
