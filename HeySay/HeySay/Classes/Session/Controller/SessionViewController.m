//
//  SessionViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "SessionViewController.h"
#import "ChatViewController.h"
#import "MainTabBarController.h"
#import "SessionTableViewCell.h"
#import "FriendModel.h"
#import "UserModel.h"
#import "SessionListManager.h"
#import "SessionModel.h"
#import "UIImageView+WebCache.h"

@interface SessionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SessionTableViewCell" bundle:nil] forCellReuseIdentifier:@"SessionTableViewCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:ReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:InertSessionOK object:nil];
}

- (void)fetchData {
    MainTabBarController *mainTVC = (MainTabBarController *)self.tabBarController;
    [[SessionListManager defaultManeger] openDatabaseWithUserAccount:mainTVC.userAccount];
    [[SessionListManager defaultManeger] createTable];
    self.dataArray = [[SessionListManager defaultManeger] selectSession];
    [self.tableView reloadData];
}

#pragma tableView代理

// MARK:行点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MainTabBarController *mainTVC = (MainTabBarController *)self.tabBarController;
    [[LeanCloudManager defaultManeger] fetchUserInfoWithAccount:mainTVC.userAccount getUserModel:^(UserModel *userModel) {
        
        [[LeanCloudManager defaultManeger] fetchAllFriendsModelWithAccount:mainTVC.userAccount getAllFriendsModel:^(NSArray *allFriendsModel) {
            
            SessionModel *sessionM = self.dataArray[indexPath.row];
            NSString *friendNickName = sessionM.friendNickName;
            
            for (FriendModel *friModel in allFriendsModel) {
                
                if ([friendNickName isEqualToString:friModel.nickName]) {
                    
                    ChatViewController *chatVC = [[ChatViewController alloc] init];
                    chatVC.friendModel = [[FriendModel alloc] init];
                    chatVC.userModel = userModel;
                    chatVC.friendModel = friModel;// 问题
                    chatVC.navigationItem.title = friModel.nickName;// 问题
                    [self.navigationController pushViewController:chatVC animated:YES];
                }
            }
            
        }];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionTableViewCell" forIndexPath:indexPath];
    
    SessionModel *model = self.dataArray[indexPath.row];
    
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:model.friendIconURL]];
    cell.nickNameLabel.text = model.friendNickName;
    cell.endTimeLabel.text = [self getDateDisplayString:model.endTime.longLongValue];
    cell.endMessageLabel.text = model.endChatLog;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)getDateDisplayString:(long long) miliSeconds {
    
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

//- (void)viewDidDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
