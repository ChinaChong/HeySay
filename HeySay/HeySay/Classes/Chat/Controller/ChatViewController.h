//
//  ChatViewController.h
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserModel;
@class FriendModel;
@interface ChatViewController : UIViewController

@property (nonatomic,strong) UserModel   *userModel;
@property (nonatomic,strong) FriendModel *friendModel;

@end
