//
//  TimeLineCell.h
//  HeySay
//
//  Created by lanou3g on 16/4/20.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineFrame.h"

typedef void(^ImageButton)(NSArray *imageViews,NSInteger clickTag);

@interface TimeLineCell : UITableViewCell
@property (nonatomic, strong)TimeLineFrame *timeLineFrame;
@property (nonatomic, strong)ImageButton imageBlock;

@end
