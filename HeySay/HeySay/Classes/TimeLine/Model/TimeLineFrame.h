//
//  TimeLineFrame.h
//  HeySay
//
//  Created by lanou3g on 16/4/20.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TimeLineModel.h"
@interface TimeLineFrame : NSObject
//头像
@property (nonatomic,assign)CGRect iconF;
//昵称
@property (nonatomic,assign)CGRect nameF;
//文本
@property (nonatomic,assign)CGRect aboutF;
//cell高度
@property (nonatomic,assign)CGFloat cellHeight;
//时间
@property (nonatomic,assign)CGRect timeF;
//评论按钮
@property (nonatomic,assign)CGRect replyButtonF;
//图片数据
@property (nonatomic,strong)NSMutableArray *picturesF;

//评论数据
@property (nonatomic,strong)NSMutableArray *replysF;
//评论背景
@property (nonatomic,assign)CGRect replyBackgroundF;

@property(nonatomic,strong)TimeLineModel *timeLineModel;




@end
