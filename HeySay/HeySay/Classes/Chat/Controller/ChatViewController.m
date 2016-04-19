//
//  ChatViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatKeyBoardInputView.h"
#import "MessageTableViewCell.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) ChatKeyBoardInputView *inputView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ChatViewController

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    [self configLeftBarBtn];
    [self configInputView];
    [self registerNotification];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)registerNotification {
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 点击发送按钮的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage:) name:ChatViewSendMessageButtonClick object:nil];
}

- (void)sendMessage:(NSNotification *)sender {
    
    NSString *text = (NSString *)[sender object];
    
    [self.dataArray addObject:text];
    
    [self.tableView reloadData];
    
    if (self.dataArray.count > 1) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
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
        self.inputView.frame = CGRectMake(0, ScreenHeight - (height + NormalHeight), ScreenWidth, NormalHeight);
    }];
    
    [self.bottomConstraint setConstant:height];
    
    [self.inputView layoutIfNeeded];
    
//    if ([conversation loadAllMessages].count > 1) {
//        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:conversation.loadAllMessages.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
//    }
    
    if (self.dataArray.count > 1) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
}

- (void)configInputView {
    
    self.inputView = [[ChatKeyBoardInputView alloc] initWithFrame:CGRectMake(0, ScreenHeight - NormalHeight, ScreenWidth, NormalHeight)];
    
    [self.view addSubview:self.inputView];
}

- (void)configLeftBarBtn {
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(popToLastVC)];
    
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)popToLastVC {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.isSend = NO;
    cell.msgContent = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = self.dataArray[indexPath.row];
    
    return [self stringHeight:text] + 30.0f;
}

- (CGFloat)stringHeight:(NSString *)aString {
    
    CGRect temp = [aString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 2 / 3 - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    NSLog(@"计算宽:%lf",[UIScreen mainScreen].bounds.size.width * 2 / 3 - 40);
    
    return temp.size.height;
}

#pragma mark - 移除通知中心
- (void)viewWillDisappear:(BOOL)animated {
    
    [self removeRorKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
