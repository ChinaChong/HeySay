//
//  RegisterViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"

@interface RegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic)   IBOutlet UIImageView *iconImg;
@property (weak, nonatomic)   IBOutlet UITextField *nickNameField;
@property (weak, nonatomic)   IBOutlet UITextField *accountField;
@property (weak, nonatomic)   IBOutlet UITextField *passWordField;
@property (weak, nonatomic)   IBOutlet UITextField *repeatPwdField;
@property (weak, nonatomic)   IBOutlet UIButton    *registerBtn;
@property (strong, nonatomic) IBOutlet UIView      *rootV;

@property (nonatomic,strong)  UIImage  *imageOfPicker;
@property (nonatomic,copy)    NSString *imageName;

@property (nonatomic,strong)  UIAlertController *alert;

@end
 
@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registerBtn.layer.cornerRadius = 4;
    self.registerBtn.layer.masksToBounds = YES;
    
    [self pickIconImg];
    
    [self registerKeyBoardNotification];
}

#pragma mark - 选取头像
- (void)pickIconImg {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickIconImage:)];
    self.iconImg.userInteractionEnabled = YES;
    [self.iconImg addGestureRecognizer:tap];
}

- (void)pickIconImage:(UITapGestureRecognizer *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

// MARK:保存图片,填写完账号,并且注册成功,再储存
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
        
    
    self.imageOfPicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.iconImg.image = self.imageOfPicker;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithType:1 andTitle:@"已设为头像"];
}

// MARK: 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *data = UIImageJPEGRepresentation(currentImage,0.5);
    
    // 拼接文件路径
    NSString *fullPath = [[NSString documentPath] stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
    
    // 将图片写入文件
    [data writeToFile:fullPath atomically:NO];
    
    NSLog(@"imagePath = %@",fullPath);
}

#pragma mark - 点击注册按钮
- (IBAction)registerBtnClick:(id)sender {
    
    // 1.所有信息不为空
    if ([self isInfoNil]) {
        
        [self showAlertViewWithType:0 andTitle:@"信息不完整"];
        return;
    }
    
    // 2.两次密码一致
    if (![self.passWordField.text isEqualToString:self.repeatPwdField.text]) {
        
        [self showAlertViewWithType:0 andTitle:@"密码不一致"];
        return;
    }
    
    // 3.账号查重(1层block)
    [[LeanCloudManager defaultManeger] duplicateCheckWithAccountID:self.accountField.text isDuplicate:^(BOOL isDuplicate) {
        
        if (isDuplicate) {
            
            [self showAlertViewWithType:0 andTitle:@"账号已存在"];
            return;
        }
        
    // 4.将头像写入沙盒
        [self saveImage:self.iconImg.image withName:self.accountField.text];
        
    // 5.将头像上传至云端(2层block)
        [[LeanCloudManager defaultManeger] getImageURLAndUploadImageWithName:self.accountField.text imageURL:^(NSString *url) {
            
    // 4.在UserInfo中创建一个用户(3层block)
            UserModel *model = [[UserModel alloc] init];
            model.accountID  = self.accountField.text;
            model.nickName   = self.nickNameField.text;
            model.passWord   = self.passWordField.text;
            model.iconUrl    = url;
            
            [[LeanCloudManager defaultManeger] createNewUser:model newUserObjectID:^(NSString *newUserObjectID) {
                
    // 5.将用户信息保存到AllID
                [[LeanCloudManager defaultManeger] addNewUserToAllIDWithAccountID:self.accountField.text andObjectID:newUserObjectID];
            }];
        }];
        
        [self showAlertViewWithType:1 andTitle:@"注册成功"];
    }];
}

- (BOOL)isInfoNil {
    if (self.accountField.text.length < 1   ||
        self.nickNameField.text.length < 1  ||
        self.passWordField.text.length < 1  ||
        self.repeatPwdField.text.length < 1 ||
        !self.accountField.text             ||
        !self.nickNameField.text            ||
        !self.passWordField.text            ||
        !self.repeatPwdField.text) {
        
        return YES;
    }
    
    return NO;
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

// MARK:移除通知中心
- (void)removeRorKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK:开始执行键盘改变后对应视图的变化
- (void)beginMoveUpAnimation:(CGFloat)height{
    [UIView animateWithDuration:0.5 animations:^{
        self.rootV.frame = CGRectMake(0,  -height, ScreenWidth, ScreenHeight);
    }];
    
    [self.rootV layoutIfNeeded];
}

// MARK:视图消失,移除通知中心
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

// MARK:返回按钮点击事件
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK:回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
