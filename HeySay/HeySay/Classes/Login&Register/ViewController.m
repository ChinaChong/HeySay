//
//  ViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "ViewController.h"
#import "MainTabBarController.h"

#import "NSString+MD5.h"

@interface ViewController ()
{
    BOOL hadLogin;
}

@property (nonatomic,strong) UIAlertController *alert;

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong, nonatomic) IBOutlet UIView *rootV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (hadLogin) {
        
        
    }
    
    [self configInterface];
    [self registerKeyBoardNotification];
}

#pragma mark - 登录
- (IBAction)loginAction:(id)sender {
    
    // 1.判断输入是否为空
    if ([self isInfoNil]) {
        
        [self showAlertViewWithType:0 andTitle:@"未填写账号或密码"];
        return;
    }
    // 2.验证账号密码
    [self checkAccountAndPassWord];
}

// MARK:验证账号密码
- (void)checkAccountAndPassWord {
    
    // 验证账号是否存在
    [[LeanCloudManager defaultManeger] duplicateCheckWithAccountID:self.accountField.text isDuplicate:^(BOOL isDuplicate) {
        
        if (isDuplicate) {
            
            // 根据账号验证密码
            [[LeanCloudManager defaultManeger] fetchPassWordWithAccount:self.accountField.text getPassWord:^(NSString *passWord) {
                
                if (![self.passWordField.text isEqualToString:passWord]) {
                    
                    [self showAlertViewWithType:0 andTitle:@"密码输入错误"];
                    return;
                }
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.label.text = @"正在登录...";
                hud.removeFromSuperViewOnHide = YES;
                
                
                ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
                
                loginInfo.username = self.accountField.text;
                loginInfo.appKey = @"aaf98f895427cf5001542c9ff6da0726";
                
                NSDate *date = [NSDate date];
                NSDateFormatter *formater = [[NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formater stringFromDate:date];
                loginInfo.timestamp = dateString; //yyyyMMddHHmmss
                
                NSString *MD5TokenString = [NSString stringWithFormat:@"%@%@%@%@",loginInfo.appKey,loginInfo.username,loginInfo.timestamp,@"c054554d4e07de0aa13535f765426734"];
                
                // MD5Token = (appid+username+timestamp+apptoken)
                loginInfo.MD5Token = [NSString stringByMD5EncryptionWith:MD5TokenString];
                loginInfo.authType = LoginAuthType_MD5TokenAuth;// 鉴权模式方式登录
                loginInfo.mode = LoginMode_InputPassword;
                
                [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
                    if (error.errorCode == ECErrorType_NoError) {
                        
                        //登录成功
                        [self jumpToMainTabBarController];
                        
                    }else{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        //登录失败
//                        NSString *message = [NSString stringWithFormat:@"错误代码:%ld",(long)error.errorCode];
                        [self showAlertViewWithType:0 andTitle:@"登录失败"];
                    }
                }];
            }];
        }else {
            
            [self showAlertViewWithType:0 andTitle:@"账号不存在"];
        }
    }];
}

- (BOOL)isInfoNil {
    
    if (self.accountField.text.length  < 1 ||
        self.passWordField.text.length < 1 ||
        !self.accountField.text            ||
        !self.passWordField.text) {
        return YES;
    }
    
    return NO;
}

// MARK:跳转进入程序
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

#pragma mark - 配置界面
- (void)configInterface {
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.registerBtn.layer.cornerRadius = 4;
    self.registerBtn.layer.masksToBounds = YES;
    
}

#pragma  mark - 回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - 注册键盘通知
- (void)registerKeyBoardNotification {
    
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// MARK:键盘将要弹出
- (void)didKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // 输入框位置动画加载
    [self beginMoveUpAnimation:keyboardSize.height];
}

// MARK:键盘将要隐藏
- (void)didKeyboardWillHide:(NSNotification *)notification{
    [self beginMoveUpAnimation:0];
}

// MARK:开始执行键盘改变后对应视图的变化
- (void)beginMoveUpAnimation:(CGFloat)height{
    [UIView animateWithDuration:0.5 animations:^{
        self.rootV.frame = CGRectMake(0, -height, ScreenWidth, ScreenHeight);
    }];
    
    [self.rootV layoutIfNeeded];
}

#pragma mark - 移除通知中心
- (void)removeRorKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self removeRorKeyboardNotifications];
}

#pragma mark - alert
- (void)showAlertViewWithType:(NSInteger)type andTitle:(NSString *)message {
    
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
    [hud hideAnimated:YES afterDelay:1.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
