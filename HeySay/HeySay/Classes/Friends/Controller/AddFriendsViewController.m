//
//  AddFriendsViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/25.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "UserModel.h"

@interface AddFriendsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *friendAccount;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configInterface];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(backAct:)];
    [backBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)backAct:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configInterface {
    
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 4;
}

- (IBAction)addAction:(id)sender {
    
    // 1.用输入的ID去判断是否存在该用户
    if (self.friendAccount.text.length < 1 || !self.friendAccount.text) return;
    
    [[LeanCloudManager defaultManeger] duplicateCheckWithAccountID:self.friendAccount.text isDuplicate:^(BOOL isDuplicate) {
        
        if (!isDuplicate) {
            [self showMBProgressHUDWithType:0 andMessage:@"账号不存在"];
            return;
        }
        
    // 2.如果存在,发送自定消息,添加该好友
        ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:@" "];
        ECMessage *message = [[ECMessage alloc] initWithReceiver:self.friendAccount.text body:messageBody];

        message.userData = AddFriends;
        [[ECDevice sharedInstance].messageManager sendMessage:message progress:nil completion:^(ECError *error,
                                                                                                ECMessage *
                                                                                                amessage) {

            if (error.errorCode == ECErrorType_NoError) {
                [self.friendAccount resignFirstResponder];
                // 发送成功
                [self showMBProgressHUDWithType:1 andMessage:@"请求已发送"];
            }else if(error.errorCode == ECErrorType_Have_Forbid || error.errorCode == ECErrorType_File_Have_Forbid)
            {
                //您已被群组禁言
                [self showMBProgressHUDWithType:0 andMessage:@"发送失败禁言"];
            }else{
                //发送失败
                [self showMBProgressHUDWithType:0 andMessage:@"发送失败"];
            }
        }];
        
    }];
    
    
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
    hud.square = YES;
    [hud hideAnimated:YES afterDelay:1.5f];
}

@end
