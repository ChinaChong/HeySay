//
//  TimeLineTableViewController.m
//  HeySay
//
//  Created by ChinaChong on 16/4/23.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "TimeLineTableViewController.h"
#import "TimeLineModel.h"
#import "TimeLineFrame.h"
#import "TimeLineCell.h"
#define TIFIER @"TimeLineCell"
@interface TimeLineTableViewController ()
@property (nonatomic, strong)NSMutableArray *TimeLineModelArray;
@end

@implementation TimeLineTableViewController

-(NSMutableArray *)TimeLineModelArray{
    if (!_TimeLineModelArray) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"FamilyGroup.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dictArray count]];
        for (NSDictionary *dict in dictArray) {
            TimeLineModel *timeLineModel = [TimeLineModel TimeLineModelWithDict:dict];
            TimeLineFrame *timeLineFrame = [[TimeLineFrame alloc]init];
            timeLineFrame.timeLineModel = timeLineModel;
            
            [models addObject:timeLineFrame];
        }
        _TimeLineModelArray = [models copy];
    }
    return _TimeLineModelArray.mutableCopy;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"朋友圈";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddAbout:)];
//    
//    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:(UIControlStateNormal)];
    
    [self.tableView registerClass:[TimeLineCell class] forCellReuseIdentifier:TIFIER];
    [self requestData];
    
    [self addHeadView];
}
//抬头
-(void)addHeadView{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headViewHeight)];
    
    
    //长按应该可以更换背景
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headViewHeight - 2*apadding)];
    backGroundImageView.image = [UIImage imageNamed:@"background.jpg"];
    [headView addSubview:backGroundImageView];
    
    
    UIImageView *headIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(apadding, headViewHeight - headIconHeight, headIconWidth, headIconHeight)];
    headIconImageView.image = [UIImage imageNamed:@"headicon"];
    [headView addSubview:headIconImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(headIconWidth + 2 * apadding, headViewHeight - 0.8*headIconHeight, 100, 15)];
    nameLabel.text = @"luyang";
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor whiteColor];
    [headView addSubview:nameLabel];
    
    self.tableView.tableHeaderView = headView;
}
//添加说说
-(void)AddAbout:(id)sender{
    
}
//数据接口
-(void)requestData{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.TimeLineModelArray) {
        return self.TimeLineModelArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动调整高度并且调整cell高度
    if (self.TimeLineModelArray) {
        TimeLineFrame *frame = self.TimeLineModelArray[indexPath.row];
        return frame.cellHeight;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeLineFrame *frame = self.TimeLineModelArray[indexPath.row];
    
    
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:TIFIER];
    if (cell == nil) {
        cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TIFIER];
    }
    cell.timeLineFrame = frame;
    //点击图片进入轮播界面
    cell.imageBlock = ^(NSArray *images,NSInteger clickTag){
        
    };
    
    return cell;
}
@end
