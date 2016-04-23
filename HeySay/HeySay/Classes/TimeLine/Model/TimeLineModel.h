//
//  TimeLineModel.h
//  Gossip
//
//  Created by lanou3g on 16/4/19.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLineModel : NSObject
@property (strong,nonatomic)NSString *icon;  //头像
@property (strong,nonatomic)NSString *name;  //昵称
@property (strong,nonatomic)NSString *about; //说说
@property (strong,nonatomic)NSDate *time;    //发表的时间
@property (strong,nonatomic)NSMutableArray *pictures;   //发表的图片
@property (strong,nonatomic)NSMutableArray *replys;   //评论
+(id)TimeLineModelWithDict:(NSDictionary *)dict;
@end
