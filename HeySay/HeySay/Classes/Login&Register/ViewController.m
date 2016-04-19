//
//  ViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "ViewController.h"
#import "MainTabBarController.h"
#import "MBProgressHUD.h"

@interface ViewController ()
{
    BOOL hadLogin;
}

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (hadLogin) {
        
        
    }
    
    [self configBtn];
    
}

- (IBAction)loginAction:(id)sender {
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";
    hud.removeFromSuperViewOnHide = YES;
    
    [self checkAccountAndPassWord];
}

- (void)checkAccountAndPassWord {
    
    // 1.用输入的账号去云端搜索,如果有,验证密码,密码不正确直接return,正确就跳转界面,如果没有直接return
    
    
    
    // 2.用输入的账号去云端搜索,如果没有直接return
    
}

- (void)jumpToMainTabBarController {
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainTabBarController *mainTBC = (MainTabBarController *)[mainStory instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    mainTBC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    __weak typeof(self) weakself = self;
    
    [self presentViewController:mainTBC animated:YES completion:^{
        
        __strong typeof(weakself) strongSelf = weakself;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
    }];
}

- (void)configBtn {
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.registerBtn.layer.cornerRadius = 4;
    self.registerBtn.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
