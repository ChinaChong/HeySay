//
//  TimeLineCell.m
//  HeySay
//
//  Created by lanou3g on 16/4/20.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "TimeLineCell.h"

#define nameFont [UIFont systemFontOfSize:12]
#define textFont [UIFont systemFontOfSize:13]
#define timeFont [UIFont systemFontOfSize:10]
#define replyFont [UIFont systemFontOfSize:13]


@interface TimeLineCell()
//控件
//头像
@property (nonatomic, strong)UIImageView *iconImage;
//昵称
@property (nonatomic, strong)UILabel *nameLabel;
//正文
@property (nonatomic, strong)UILabel *aboutLabel;
//图片
@property (nonatomic, strong)UIImageView *pictures;
//时间
@property (nonatomic, strong)UILabel *timeLabel;
//评论背景
@property (nonatomic, strong)UIImageView *replyBackgroundView;
//评论按钮
@property (nonatomic, strong)UIButton *replyButton;
//数据
//图片组
@property (nonatomic, strong)NSMutableArray *pictiresArray;
//评论组
@property (nonatomic, strong)NSMutableArray *replyArray;

@end

@implementation TimeLineCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加头像
        UIImageView *iconImage = [[UIImageView alloc] init];
        [self.contentView addSubview:iconImage];
        self.iconImage = iconImage;
        //添加昵称
        UILabel *nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:nameLabel];
        nameLabel.font = nameFont;
        nameLabel.textColor = [UIColor colorWithRed:77/255.0 green:182/255.0 blue:172/255.0 alpha:1];
        self.nameLabel = nameLabel;
        //添加说说控件
        UILabel *aboutLabel = [[UILabel alloc] init];
        
        aboutLabel.font = textFont;
        aboutLabel.textColor = [UIColor colorWithRed:77/255.0 green:77/255.0 blue:77/255.0 alpha:1];
        [self.contentView addSubview:aboutLabel];
        self.aboutLabel = aboutLabel;
        self.aboutLabel.numberOfLines = 0;
//        //添加多个图片显示控件
//        UICollectionView *picturesCV = [[UICollectionView alloc] init];
//        [self.contentView addSubview:picturesCV];
//        self.picturesCV = picturesCV;
//        //添加单个视图显示控件
//        UIImageView *pictures = [[UIImageView alloc] init];
//        [self.contentView addSubview:pictures];
//        self.pictures = pictures;
        //添加时间标签
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = timeFont;
        timeLabel.textColor =[UIColor colorWithRed:152/255.0 green:152/255.0 blue:152/255.0 alpha:1];
        [self.contentView addSubview:timeLabel];
         self.timeLabel = timeLabel;
        //创建评论按钮
        UIButton *replyButton = [UIButton buttonWithType:0];
        [replyButton setImage:[UIImage imageNamed:@"reply"] forState:0];
        [self.contentView addSubview:replyButton];
        self.replyButton = replyButton;
        //创建评论背景
        UIImageView *replyBackgroundView = [[UIImageView alloc]init];
        replyBackgroundView.backgroundColor =[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:replyBackgroundView];
        self.replyBackgroundView = replyBackgroundView;
       
    }
    return self;
}
-(NSMutableArray *)replyArray{
    if (!_replyArray) {
        _replyArray =[[NSMutableArray alloc]init];
    }
    return _replyArray;
}
-(NSMutableArray *)pictiresArray{
    if (!_pictiresArray) {
        _pictiresArray = [[NSMutableArray alloc] init];
    }
    return _pictiresArray;
}
//@property (nonatomic, strong)UIImageView *iconImage;
//@property (nonatomic, strong)UILabel *nameLabel;
//@property (nonatomic, strong)UILabel *aboutLabel;
//@property (nonatomic, strong)UICollectionView *picturesCV;
//@property (nonatomic, strong)UIImageView *pictures;
//@property (nonatomic, strong)UILabel *timeLabel;
//@property (nonatomic, strong)UIImageView *replyBackgroundView;
//@property (nonatomic, strong)UIButton *replyButton;
-(void)setTimeLineFrame:(TimeLineFrame *)timeLineFrame{
    _timeLineFrame = timeLineFrame;
    [self removeOldPicturesAndReplys];
    [self settingData];
    [self settingFrame];
    
}

-(void)settingData{

    TimeLineModel *timeLineModel = self.timeLineFrame.timeLineModel;
    
    //创建头像
    self.iconImage.image = [UIImage imageNamed:timeLineModel.icon];
    
    //创建昵称
    self.nameLabel.text = timeLineModel.name;
    
    //创建正文
    self.aboutLabel.text = timeLineModel.about;
    
    //创建配图
    for (int i = 0; i < [timeLineModel.pictures count]; i++) {
        UIImageView *pictureView = [[UIImageView alloc]init];
        //为图片添加点击时间
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureView addGestureRecognizer:tap];
        pictureView.tag = ImageTag + i;
    
        pictureView.userInteractionEnabled = YES;
        [self.contentView addSubview:pictureView];
        [self.pictiresArray addObject:pictureView];
        ((UIImageView *)[self.pictiresArray objectAtIndex:i]).image = [UIImage imageNamed:[timeLineModel.pictures objectAtIndex:i]];
    }
    
    //时间戳
        NSTimeInterval  timeInterval = [timeLineModel.time timeIntervalSinceNow];
        timeInterval = -timeInterval;
        long temp = 0;
        NSString *result;
        if (timeInterval < 60) {
            result = [NSString stringWithFormat:@"刚刚"];
        }
        else if((temp = timeInterval/60) <60){
            result = [NSString stringWithFormat:@"%ld分前",temp];
        }
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"%ld小前",temp];
        }
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"%ld天前",temp];
        }
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"%ld月前",temp];
        }
        else{
            result = [NSString stringWithFormat:@"%@",timeLineModel.time];
        }
    self.timeLabel.text = result;
    
    //创建评论
    for (int i = 0; i < [timeLineModel.replys count]; i++) {
        UILabel *replyLabel = [[UILabel alloc]init];
        replyLabel.font = replyFont;
        replyLabel.numberOfLines = 0;
        
        NSString *searchText = [timeLineModel.replys objectAtIndex:i];
        
        NSRange range = [searchText rangeOfString:@"([\u4e00-\u9fa5]|[a-zA-Z0-9])+：" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:searchText];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:104/255.0 green:109/255.0 blue:248/255.0 alpha:1.0] range:NSMakeRange(0, range.length - 1)];
            replyLabel.attributedText = str;
        }
        else
        {
            replyLabel.text = [timeLineModel.replys objectAtIndex:i];
        }
        [self.contentView addSubview:replyLabel];
        [self.replyArray addObject:replyLabel];
    }
}
-(void)tapImageView:(UIGestureRecognizer *)tap{
    self.imageBlock(self.timeLineFrame.picturesF,tap.view.tag);
}

-(void)settingFrame{
    //头像frame
    self.iconImage.frame = self.timeLineFrame.iconF;
    //昵称frame
    self.nameLabel.frame = self.timeLineFrame.nameF;
    //正文frame
    self.aboutLabel.frame = self.timeLineFrame.aboutF;
    //评论按钮
    self.replyButton.frame = self.timeLineFrame.replyButtonF;
    //评论消息背景
    self.replyBackgroundView.frame = self.timeLineFrame.replyBackgroundF;
    for (int i = 0; i < [self.timeLineFrame.picturesF count]; i++) {
        ((UIImageView *)[self.pictiresArray objectAtIndex:i]).frame = [((NSValue *)[self.timeLineFrame.picturesF objectAtIndex:i]) CGRectValue];
    }
    for (int i = 0; i < [self.timeLineFrame.replysF count]; i++) {
        ((UILabel *)[self.replyArray objectAtIndex:i]).frame = [(NSValue *)[self.timeLineFrame.replysF objectAtIndex:i] CGRectValue];
    }

    //发表时间
    self.timeLabel.frame = self.timeLineFrame.timeF;
}


-(void)removeOldPicturesAndReplys
{
    for(int i = 0;i < [self.pictiresArray count];i++)
    {
        UIImageView *pictureView = [self.pictiresArray objectAtIndex:i];
        if (pictureView.superview) {
            [pictureView removeFromSuperview];
        }
    }
    for (int i = 0; i < [self.replyArray count]; i++) {
        UILabel *replyView = [self.replyArray objectAtIndex:i];
        if (replyView.superview) {
            [replyView removeFromSuperview];
        }
    }
    [self.pictiresArray removeAllObjects];
    [self.replyArray removeAllObjects];
}
@end
