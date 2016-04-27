//
//  MainTabBarController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "MainTabBarController.h"
#import "ChatLogModel.h"
#import "ChatLogManager.h"
#import "FriendModel.h"
#import "SessionModel.h"
#import "SessionListManager.h"
#import "UserModel.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (UIBarItem *item in self.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:11.5], NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    
    // 接收消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMyReceiveMessage:) name:KNOTIFICATION_onMesssageChanged object:nil];
}

// MARK:接收加好友消息
- (void)onMyReceiveMessage:(NSNotification *)sender {
    
    ECMessage *message = (ECMessage *)[sender object];
    
    if ([message.userData isEqualToString:AddFriends]) {
        [self showAddFriendsAlertWithAccount:message.from];
    }else if([message.userData isEqualToString:AccpetRequest]) {
        [self showMBProgressHUDWithType:1 andMessage:[NSString stringWithFormat:@"%@同意了你的请求",message.from]];
        [[NSNotificationCenter defaultCenter] postNotificationName:AccpetRequest object:nil];
    }else if([message.userData isEqualToString:RejectRequest]){
        [self showMBProgressHUDWithType:0 andMessage:[NSString stringWithFormat:@"%@拒绝了你的请求",message.from]];
    }else if (!message.userData) {
            
        ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
        ChatLogModel *model = [[ChatLogModel alloc] init];
        model.isSend = NO;
        model.message = msgBody.text;
        [[ChatLogManager defaultManeger] openDatabaseWithUserAccount:self.userAccount];
        [[ChatLogManager defaultManeger] createTableWithTableName:message.from];
        [[ChatLogManager defaultManeger] insertChatLogWithChatLogModel:model withTableName:message.from];
        
        // 会话
        [[LeanCloudManager defaultManeger] fetchUserInfoWithAccount:message.from getUserModel:^(UserModel *userModel) {
            
            SessionModel *sessionModel = [[SessionModel alloc] init];
            
            sessionModel.friendNickName = userModel.nickName;
            sessionModel.friendIconURL = userModel.iconUrl;
            ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
            sessionModel.endChatLog = msgBody.text;
            sessionModel.endTime = message.timestamp;
            
            // 插入数据库
            [[SessionListManager defaultManeger] openDatabaseWithUserAccount:self.userAccount];
            [[SessionListManager defaultManeger] createTable];
            [[SessionListManager defaultManeger] insertSessionWithSessionModel:sessionModel];
            [[NSNotificationCenter defaultCenter] postNotificationName:ReceiveMessage object:nil];
        }];
        
    }
}

- (void)showAddFriendsAlertWithAccount:(NSString *)account {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"来自\"%@\"的好友请求",account] message:[NSString stringWithFormat:@"TA想添加你为好友"] preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"同意" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:@" "];
        ECMessage *message = [[ECMessage alloc] initWithReceiver:account body:messageBody];
        
        message.userData = AccpetRequest;
        [[ECDevice sharedInstance].messageManager sendMessage:message progress:nil completion:^(ECError *error,
                                                                                                ECMessage *
                                                                                                amessage) {
            if (error.errorCode == ECErrorType_NoError) {
                // 发送成功,双方添加好友关系
                [[LeanCloudManager defaultManeger] insertFriendAccount:account userAccount:self.userAccount friendIsSucceeded:^(BOOL isSucceeded) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:NewFriend object:@(isSucceeded)];
                } userIsSucceeded:^(BOOL isSucceeded) {
                    
                    // 注册一个通知,告诉好友列表添加上了新好友,刷新UI
                    [[NSNotificationCenter defaultCenter] postNotificationName:NewFriend object:@(isSucceeded)];
                }];
                
            }
        }];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"拒绝" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:@" "];
        ECMessage *message = [[ECMessage alloc] initWithReceiver:account body:messageBody];
        
        message.userData = RejectRequest;
        [[ECDevice sharedInstance].messageManager sendMessage:message progress:nil completion:^(ECError *error,
                                                                                                ECMessage *
                                                                                                amessage) {
        }];
    }];
    
    [alert addAction:act1];
    [alert addAction:act2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showMBProgressHUDWithType:(NSInteger)type andMessage:(NSString *)message {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    if (type == 0) {
        
        UIImage *image = [[UIImage imageNamed:@"jinggao"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        
    }else {
        
        UIImage *image = [[UIImage imageNamed:@"Done"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }
    
    hud.label.text = NSLocalizedString(message, @"HUD done title");
    hud.label.font = [UIFont systemFontOfSize:13];
    hud.square = YES;
    [hud hideAnimated:YES afterDelay:1.5f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
