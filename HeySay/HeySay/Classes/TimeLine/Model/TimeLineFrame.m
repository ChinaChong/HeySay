//
//  TimeLineFrame.m
//  HeySay
//
//  Created by lanou3g on 16/4/20.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "TimeLineFrame.h"
#define nameFont [UIFont systemFontOfSize:15]
#define aboutFont [UIFont systemFontOfSize:14]
#define replytextFont [UIFont systemFontOfSize:14]
@implementation TimeLineFrame


-(void)setTimeLineModel:(TimeLineModel *)timeLineModel{
    _timeLineModel = timeLineModel;
    
    //iconF头像
    CGFloat iconViewX = apadding;
    CGFloat iconViewY = apadding;
    CGFloat iconViewWidth = 40;
    CGFloat iconViewHeight = 40;
    self.iconF = CGRectMake(iconViewX, iconViewY, iconViewWidth, iconViewHeight);
    //nameF昵称
    CGFloat nameLabelX = CGRectGetMaxX(self.iconF) + apadding;
    CGSize nameLabelSize = [self sizeWithString:self.timeLineModel.name font:nameFont maxSize:CGSizeMake(MAXFLOAT,MAXFLOAT)];
    CGFloat nameLabelY= iconViewY;
    CGFloat nameLabelWidth = nameLabelSize.width;
    CGFloat nameLabelHeight = nameLabelSize.height;
    self.nameF = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, nameLabelHeight);
    
    //about正文
    if (self.timeLineModel.about != nil) {
        CGFloat aboutX = nameLabelX;
        CGFloat aboutY = CGRectGetMaxY(self.nameF) + apadding/2;
        CGSize aboutSize = [self sizeWithString:self.timeLineModel.about font:aboutFont maxSize:CGSizeMake(screenWidth - nameLabelX - apadding, MAXFLOAT)];
        CGFloat aboutLabelWidth = aboutSize.width;
        CGFloat aboutLabelHeight = aboutSize.height;
        self.aboutF = CGRectMake(aboutX, aboutY, aboutLabelWidth, aboutLabelHeight);
    }
    //当图片大于1张时
    if ([self.timeLineModel.pictures count]) {//数据源不为nil
        CGFloat picturesViewWidth;
        CGFloat picturesViewHeight;
        if (self.timeLineModel.pictures.count == 1) {
            picturesViewWidth = 120;
            picturesViewHeight = 120;
        }else{//图片等于1时
            picturesViewWidth = 70;
            picturesViewHeight = 70;
        }
        for (int i = 0; i < [self.timeLineModel.pictures count]; i++) {
            CGFloat picturesViewX = nameLabelX + (i%3)*(picturesViewWidth + apadding);
            CGFloat picturesViewY = CGRectGetMaxY(self.aboutF) + apadding + (apadding + picturesViewHeight)*(i/3);
            CGRect pictureF = CGRectMake(picturesViewX, picturesViewY, picturesViewWidth, picturesViewHeight);
            [self.picturesF addObject:[NSValue valueWithCGRect:pictureF]];   //NSValue可以封装c/c++类型，让ios数组能够添加
        }
        self.cellHeight = CGRectGetMaxY([(NSValue *)[self.picturesF lastObject] CGRectValue])+apadding;
    }else{
        self.cellHeight = CGRectGetMaxY(self.aboutF) + apadding;
    }
    
    //发表时间
    CGFloat timeWidth = 50;
    CGFloat timeHeight = 15;
    CGFloat timeX = nameLabelX;
    CGFloat timeY = self.cellHeight;
    self.timeF = CGRectMake(timeX, timeY, timeWidth, timeHeight);
    //评论按钮
    CGFloat replyButtonWidth = 35;
    CGFloat replyButtonHeight = 25;
    CGFloat replyButtonX = screenWidth - apadding -replyButtonWidth;
    CGFloat replyButtonY = self.cellHeight;
    self.replyButtonF = CGRectMake(replyButtonX, replyButtonY, replyButtonWidth, replyButtonHeight);
    self.cellHeight = CGRectGetMaxY(self.replyButtonF)+apadding;
    
    
    if ([self.replysF count]) {//评论组消息不为空
        CGFloat replyLabelX = nameLabelX + apadding/2;
        for (int i = 0; i < [self.timeLineModel.replys count]; i++) {
            CGSize replyLabelSize = [self sizeWithString:[self.timeLineModel.replys objectAtIndex:i] font:replytextFont maxSize:CGSizeMake(screenWidth - 2*apadding - nameLabelX, MAXFLOAT)];
            CGFloat replyLabelY = self.cellHeight;
            CGFloat replyLabelWidth = replyLabelSize.width;
            CGFloat replyLabelHeight = replyLabelSize.height;
            self.cellHeight += apadding +replyLabelHeight;
            CGRect replyF = CGRectMake(replyLabelX, replyLabelY, replyLabelWidth, replyLabelHeight);
            [self.replysF addObject:[NSValue valueWithCGRect:replyF]];
        }
        //评论的背景
        self.cellHeight = CGRectGetMaxY([(NSValue *)[self.replysF lastObject] CGRectValue]) + apadding;
        CGFloat replyBackgroundWidth = screenWidth - 1.5*apadding -nameLabelX;
        CGFloat replyBackgroundHeight = self.cellHeight - apadding*2 - CGRectGetMaxY(self.replyButtonF);
        self.replyBackgroundF = CGRectMake(nameLabelX, CGRectGetMaxY(self.replyButtonF) + apadding, replyBackgroundWidth, replyBackgroundHeight);
    }
    
}
-(CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
//    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
//    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.font = font;
    textLabel.text = str;
    textLabel.numberOfLines= 0;
    textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize size = [textLabel sizeThatFits:maxSize];
    return size;
}

-(NSMutableArray *)replysF{
    if (!_replysF) {
        _replysF = [[NSMutableArray alloc]init];
    }
    return _replysF;
}
-(NSMutableArray *)picturesF{
    if (!_picturesF) {
        _picturesF = [[NSMutableArray alloc] init];
    }
    return _picturesF;
}
@end
