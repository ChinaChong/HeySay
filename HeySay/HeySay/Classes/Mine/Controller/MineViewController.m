//
//  MineViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "MineViewController.h"
#import "MainTabBarController.h"
#import "PersonInfoViewController.h"
#import "AboutUsViewController.h"
#import "ViewController.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "AboutUsViewController.h"
#import "PersonInfoViewController.h"

@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *mineImgV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *aboutUs;
@property (weak, nonatomic) IBOutlet UIButton *signOut;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBtns];
    
    [self configInfo];
}

- (void)configBtns {
    self.aboutUs.layer.cornerRadius = 4;
    self.signOut.layer.cornerRadius = 4;
    self.exitBtn.layer.cornerRadius = 4;
    self.aboutUs.layer.masksToBounds = YES;
    self.signOut.layer.masksToBounds = YES;
    self.exitBtn.layer.masksToBounds = YES;
    self.mineImgV.layer.cornerRadius = self.mineImgV.bounds.size.width * 0.5;
    self.mineImgV.layer.masksToBounds = YES;
}

- (void)configInfo {
    MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;
    [[LeanCloudManager defaultManeger] fetchUserInfoWithAccount:mainTBC.userAccount getUserModel:^(UserModel *userModel) {
        
        [self.mineImgV sd_setImageWithURL:[NSURL URLWithString:userModel.iconUrl]];
        self.nickNameLabel.text = userModel.nickName;
    }];
}

- (void)SignOut {
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *VC = [mainStory instantiateViewControllerWithIdentifier:@"Login"];
    
    VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注销...";
    hud.removeFromSuperViewOnHide = YES;
    __block typeof(self) weakself = self;
    [[ECDevice sharedInstance] logout:^(ECError *error) {
        //登出结果
        NSLog(@"%@",error);
        __strong typeof(weakself) strongSelf = weakself;
        [self presentViewController:VC animated:YES completion:nil];
        
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        
        
    }];
    
}
- (IBAction)aboutUs:(id)sender {
    AboutUsViewController *aboutUs = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    
    aboutUs.textView.userInteractionEnabled = NO;
    [self.navigationController pushViewController:aboutUs animated:YES];
}

- (IBAction)signOutAction:(id)sender {
    [self SignOut];
}

- (IBAction)exitAction:(id)sender {
    abort();
}

@end
