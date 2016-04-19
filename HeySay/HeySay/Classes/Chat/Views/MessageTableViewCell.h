//
//  MessageTableViewCell.h
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

// 收消息还是发消息
@property (nonatomic) BOOL isSend;

// 内容
@property (nonatomic,strong) NSString *msgContent;

@property (nonatomic,strong)UILabel *contentLable;

@end
