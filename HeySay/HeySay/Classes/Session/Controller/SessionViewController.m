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

@interface SessionViewController ()

@end

@implementation SessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)jumpToChat:(id)sender {
    
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    
    MainTabBarController *mainTVC = (MainTabBarController *)self.tabBarController;
    
    chatVC.userAccount = mainTVC.userAccount;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
