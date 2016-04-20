//
//  RegisterViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UITextField *nickNameField;
@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UITextField *repeatPwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic,strong) UIImage  *imageOfPicker;
@property (nonatomic,copy)   NSString *imageName;


@property (strong, nonatomic) IBOutlet UIView *rootV;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.registerBtn.layer.cornerRadius = 4;
    self.registerBtn.layer.masksToBounds = YES;
    
    [self pickIconImg];
    
    [self registerKeyBoardNotification];
}

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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选这张图片作为头像" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        self.imageOfPicker = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.iconImg.image = self.imageOfPicker;
        
        // !!!:先不储存
//        [self saveImage:self.imageOfPicker withName:[self.accountField.text stringByAppendingString:@"IconImg.jpg"]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"重选" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:act1];
    [alert addAction:act2];
    
    [picker presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 保存图片至沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *data = UIImageJPEGRepresentation(currentImage,0.5);
    //    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    
    // 获取沙盒目录
    NSString *fullPath = [[NSString documentPath] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [data writeToFile:fullPath atomically:NO];
    
    NSLog(@"imagePath = %@",fullPath);
}

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
        self.rootV.frame = CGRectMake(0,  -height, ScreenWidth, ScreenHeight);
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
