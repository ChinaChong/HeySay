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

@property (strong, nonatomic) IBOutlet UIView *rootV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (hadLogin) {
        
        
    }
    
    [self configBtn];
    [self registerKeyBoardNotification];
}

- (IBAction)loginAction:(id)sender {
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录...";
    hud.removeFromSuperViewOnHide = YES;
    
    [self performSelector:@selector(jumpToMainTabBarController) withObject:nil afterDelay:2];
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)registerKeyBoardNotification {
    
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

// 键盘将要弹出

- (void)didKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // 输入框位置动画加载
    [self beginMoveUpAnimation:keyboardSize.height];
}

// 键盘将要隐藏
- (void)didKeyboardWillHide:(NSNotification *)notification{
    [self beginMoveUpAnimation:0];
}

// 移除通知中心
- (void)removeRorKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 开始执行键盘改变后对应视图的变化
- (void)beginMoveUpAnimation:(CGFloat)height{
    [UIView animateWithDuration:0.5 animations:^{
        self.rootV.frame = CGRectMake(0, -height, ScreenWidth, ScreenHeight);
    }];
    
    [self.rootV layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self removeRorKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
