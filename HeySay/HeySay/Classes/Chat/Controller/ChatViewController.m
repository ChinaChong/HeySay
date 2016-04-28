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
#import "UserModel.h"
#import "ChatLogModel.h"
#import "ChatLogManager.h"
#import "SessionModel.h"
#import "SessionListManager.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BOOL isSend;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic,strong) ChatKeyBoardInputView *inputView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ChatViewController

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        [[ChatLogManager defaultManeger] openDatabaseWithUserAccount:self.userModel.accountID];
        
        NSMutableArray *arr = [[ChatLogManager defaultManeger] selectChatLogWithTableName:self.friendModel.accountID];
        
        if (arr) {
            _dataArray = [NSMutableArray arrayWithArray:arr];
        }else {
            _dataArray = [NSMutableArray array];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSLog(@"路径::%@",path);
    
    isSend = YES;
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    [self configLeftBarBtn];
    [self configInputView];
    [self registerNotification];
    [self.tableView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:@"Cell"];
//    self.tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.dataArray.count > 1) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
    }
}

#pragma mark - 注册各类通知
- (void)registerNotification {
    // 使用NSNotificationCenter 注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChatKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 使用NSNotificationCenter 注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChatKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 点击发送按钮的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessage:) name:ChatViewSendMessageButtonClick object:nil];
    
    // 接收消息的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChatReceiveMessage:) name:KNOTIFICATION_onMesssageChanged object:nil];
}

// MARK:发送消息
- (void)sendMessage:(NSNotification *)sender {
    
    /**
     *  发送
     *  1.判断信息不为空
     */
    
    NSString *text = (NSString *)[sender object];
    
    ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:text];
    
    ECMessage *message = [[ECMessage alloc] initWithReceiver:self.friendModel.accountID body:messageBody];
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
    
    ChatLogModel *chatModel = [[ChatLogModel alloc] init];
    chatModel.isSend = YES;
    chatModel.message = text;
    
    [self.dataArray addObject:chatModel];// 添加数据源
    
    [[ECDevice sharedInstance].messageManager sendMessage:message progress:nil completion:^(ECError *error,
                                                                                            ECMessage *amessage) {
        
        if (error.errorCode == ECErrorType_NoError) {
            
            // 发送成功,存到本地数据库
            ECTextMessageBody *msgBody = (ECTextMessageBody *)amessage.messageBody;
            ChatLogModel *model = [[ChatLogModel alloc] init];
            model.isSend = YES;
            model.message = msgBody.text;
            [[ChatLogManager defaultManeger] openDatabaseWithUserAccount:self.userModel.accountID];
            [[ChatLogManager defaultManeger] createTableWithTableName:self.friendModel.accountID];
            [[ChatLogManager defaultManeger] insertChatLogWithChatLogModel:model withTableName:self.friendModel.accountID];
            
            // 会话
            [[LeanCloudManager defaultManeger] fetchUserInfoWithAccount:self.friendModel.accountID getUserModel:^(UserModel *userModel) {
                
                SessionModel *sessionModel = [[SessionModel alloc] init];
                
                sessionModel.friendNickName = userModel.nickName;
                sessionModel.friendIconURL = userModel.iconUrl;
                ECTextMessageBody *msgBody = (ECTextMessageBody *)amessage.messageBody;
                sessionModel.endChatLog = msgBody.text;
                sessionModel.endTime = message.timestamp;
                
                // 插入数据库
                [[SessionListManager defaultManeger] openDatabaseWithUserAccount:self.userModel.accountID];
                [[SessionListManager defaultManeger] createTable];
                [[SessionListManager defaultManeger] insertSessionWithSessionModel:sessionModel];
                [[NSNotificationCenter defaultCenter] postNotificationName:InertSessionOK object:nil];
            }];
            
            // 发送成功
            // 滚动到最后一行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
            
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            
            if (self.dataArray.count > 1) {
                
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
            }
        }else if(error.errorCode == ECErrorType_Have_Forbid || error.errorCode == ECErrorType_File_Have_Forbid)
        {
            //您已被群组禁言
            NSLog(@"禁言");
        }else{
            //发送失败
            NSLog(@"发送失败");
        }
    }];
    
}

// MARK:接收消息
-(void)onChatReceiveMessage:(NSNotification *)sender {
    
    ECMessage *message = (ECMessage *)[sender object];
    
    if (message.userData) {
        return;
    }
    
    NSString *dateString  = [self getDateDisplayString:message.timestamp.longLongValue];
    
    NSLog(@"%@",dateString);
    
    ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
    ChatLogModel *model = [[ChatLogModel alloc] init];
    model.isSend = NO;
    model.message = msgBody.text;
    
    [self.dataArray addObject:model];// 添加数据源
    
    // 滚动到最后一行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
    if (self.dataArray.count > 1) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:YES];
    }
}

// MARK:!!!!!!!!!!!!!!!时间显示内容
-(NSString *)getDateDisplayString:(long long) miliSeconds{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"今天 HH:mm:ss";
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天 HH:mm:ss";
        } else {
            dateFmt.dateFormat = @"MM-dd HH:mm:ss";
        }
    }
    return [dateFmt stringFromDate:myDate];
}

// MARK:键盘将要弹出
- (void)didChatKeyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    // 输入框位置动画加载
    [self beginMoveUpAnimation:keyboardSize.height];
}

// MARK:键盘将要隐藏
- (void)didChatKeyboardWillHide:(NSNotification *)notification{
    [self beginMoveUpAnimation:0];
}

// MARK:移除通知中心
- (void)removeRorKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK:开始执行键盘改变后对应视图的变化
- (void)beginMoveUpAnimation:(CGFloat)height{
    [UIView animateWithDuration:0.5 animations:^{
        self.inputView.frame = CGRectMake(0, ScreenHeight - (height + 60), ScreenWidth, 60);
        [self.bottomConstraint setConstant:height + 16];
    }];
    
    
    [self.inputView layoutIfNeeded];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.dataArray.count > 1) {
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
        
    });
}

#pragma mark - 键盘回收
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [self.inputView endEditing:YES];
//}

#pragma mark - 配置聊天输入框
- (void)configInputView {
    
    self.inputView = [[ChatKeyBoardInputView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 60, ScreenWidth, 60)];
    self.inputView.backgroundColor =  [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    self.inputView.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];
}

#pragma mark - 配置leftBarButtonItem
- (void)configLeftBarBtn {
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStyleDone) target:self action:@selector(popToLastVC)];
    [backBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:(UIControlStateNormal)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

// MARK:leftBarButtonItem的点击方法
- (void)popToLastVC {
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ChatLogModel *model = self.dataArray[indexPath.row];
    
//    ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
    
    if (model.isSend) {
        cell.iconURL = self.userModel.iconUrl;
        cell.isSend = YES;
    }else{
        cell.iconURL = self.friendModel.iconURL;
        cell.isSend = NO;
    }
    cell.msgContent = model.message;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatLogModel *model = self.dataArray[indexPath.row];
    
//    ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
    
    NSString *text = model.message;
    
    return [self stringHeight:text] + 30.0f;
}

// MARK:计算字符串的自适应高度
- (CGFloat)stringHeight:(NSString *)aString {
    
    CGRect temp = [aString boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width * 2 / 3 - 40, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
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
