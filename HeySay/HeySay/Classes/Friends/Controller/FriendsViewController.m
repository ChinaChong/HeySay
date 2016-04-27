//
//  FriendsViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/22.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "FriendsViewController.h"
#import "AddFriendsViewController.h"
#import "MainTabBarController.h"
#import "FriendModel.h"
#import "FriendTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "ChatViewController.h"

@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchFriends];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    
    [self registerNotification];
}

#pragma mark - 注册各类通知
- (void)registerNotification {
    // 添加好友,成功则刷新UI
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendAction:) name:NewFriend object:nil];
    // 删除好友,成功则刷新UI
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriendAction:) name:DeleteFriend object:nil];
    // 对方同意了好友请求,刷新UI
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accpetRequest:) name:AccpetRequest object:nil];
}

- (void)accpetRequest:(NSNotification *)sender {
    [self fetchFriends];
}

- (void)newFriendAction:(NSNotification *)sender {
    NSNumber *boo = [sender object];
    NSString *flag = [NSString stringWithFormat:@"%@",boo];
    if ([flag isEqualToString:@"1"]) [self fetchFriends];
}

- (void)deleteFriendAction:(NSNotification *)sender {
    NSNumber *boo = [sender object];
    NSString *flag = [NSString stringWithFormat:@"%@",boo];
    if ([flag isEqualToString:@"1"]) [self fetchFriends];
}

#pragma mark - 获取好友及用户信息
- (void)fetchFriends {
    
    MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;

    [[LeanCloudManager defaultManeger] fetchAllFriendsModelWithAccount:mainTBC.userAccount getAllFriendsModel:^(NSArray *allFriendsModel) {
        self.dataArray = [NSMutableArray arrayWithArray:allFriendsModel];
        [self.tableView reloadData];
    }];
}

- (void)fetchUser {
    
    
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell" forIndexPath:indexPath];
    
    FriendModel *model = self.dataArray[indexPath.row];
    
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.iconURL]];
    cell.nickNameLabel.text = model.nickName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// MARK:指定行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

// MARK:点击cell进入聊天
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MainTabBarController *mainTBC = (MainTabBarController *)self.tabBarController;
    [[LeanCloudManager defaultManeger] fetchUserInfoWithAccount:mainTBC.userAccount getUserModel:^(UserModel *userModel) {
        
        FriendModel *model            = self.dataArray[indexPath.row];
        
        ChatViewController *chatVC    = [[ChatViewController alloc] init];
        chatVC.friendModel = [[FriendModel alloc] init];
        chatVC.userModel              = userModel;
        
        chatVC.friendModel.accountID  = model.accountID;
        chatVC.friendModel.iconURL    = model.iconURL;
        chatVC.friendModel.objectID   = model.objectID;
        chatVC.navigationItem.title   = model.nickName;
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }];
    
}
// MARK:侧滑删除好友

// MARK:点击添加好友
- (IBAction)addFriend:(id)sender {
    
    AddFriendsViewController *addVC = [[AddFriendsViewController alloc] initWithNibName:@"AddFriendsViewController" bundle:nil];
    
    addVC.navigationItem.title = @"添加好友";
    
    [self.navigationController pushViewController:addVC animated:YES];
}

@end
