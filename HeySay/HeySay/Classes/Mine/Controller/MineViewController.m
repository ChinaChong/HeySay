//
//  MineViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/19.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "MineViewController.h"
#import "ViewController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self .tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"注销";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ViewController *VC = [mainStory instantiateViewControllerWithIdentifier:@"Login"];
    
    VC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注销...";
    hud.removeFromSuperViewOnHide = YES;
    
    __weak typeof(self) weakself = self;
    
    [self presentViewController:VC animated:YES completion:^{
        
        __strong typeof(weakself) strongSelf = weakself;
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
    }];
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
