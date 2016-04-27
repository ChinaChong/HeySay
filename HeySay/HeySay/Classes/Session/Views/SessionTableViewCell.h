//
//  SessionTableViewCell.h
//  HeySay
//
//  Created by ChinaChong on 16/4/27.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endMessageLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;


@end
