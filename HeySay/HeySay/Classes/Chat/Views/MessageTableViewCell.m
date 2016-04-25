//
//  MessageTableViewCell.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface MessageTableViewCell ()


@property (nonatomic,strong)UIImageView *backGImageView;
@property (nonatomic,strong)UIImageView *headImageView;
@property (nonatomic,strong)UILabel *contentLable;


@end

@implementation MessageTableViewCell

- (UILabel *)contentLable {
    if (_contentLable == nil) {
        _contentLable = [[UILabel alloc] init];
    }
    return _contentLable;
}

- (UIImageView *)backGImageView {
    if (_backGImageView == nil) {
        _backGImageView = [[UIImageView alloc] init];
    }
    return _backGImageView;
}

- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.backGImageView];
        [self.contentView addSubview:self.headImageView];
        [self.backGImageView addSubview:self.contentLable];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)awakeFromNib {
}

// 根据发送方设置头像
- (void)setIsSend:(BOOL)isSend {
    CGRect cellRect = self.bounds;
    _isSend = isSend;
    if (_isSend) {
        self.headImageView.frame = CGRectMake(cellRect.size.width - 50, 5, 38, 38);
        if (self.iconURL) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.iconURL]];
            return;
        }
        self.headImageView.backgroundColor = [UIColor greenColor];
    }else{
        self.headImageView.frame = CGRectMake(10, 5, 38, 38);
        if (self.iconURL) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.iconURL]];
            return;
        }
        self.headImageView.backgroundColor = [UIColor greenColor];
    }
}


- (void)setMsgContent:(NSString *)msgContent {
    // 通过内容计算对话泡
    if (_msgContent != msgContent) {
        _msgContent = nil;
        _msgContent = msgContent;
        self.contentLable.text = _msgContent;
        
        CGRect cellRect = self.bounds;
        
        CGRect frame = self.contentLable.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width * 2 / 3 - 40;
        
        [self.contentLable setFrame:frame];
        self.contentLable.backgroundColor = [UIColor clearColor];
        
        self.contentLable.font = [UIFont systemFontOfSize:14];
        self.contentLable.numberOfLines = 0;
        
        // 百度搜一下
//        self.contentLable.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentLable sizeToFit];
        
        if (self.isSend) {
            //对话泡图片的使用
            self.backGImageView.image = [[UIImage imageNamed:@"chat_sender_bg@2x.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:27];
            self.backGImageView.frame = CGRectMake(cellRect.size.width - 40 - self.contentLable.frame.size.width - 50, 5, self.contentLable.frame.size.width + 40, cellRect.size.height - 10);
            
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            self.contentLable.center = CGPointMake(self.backGImageView.frame.size.width * 0.5 - 5, self.backGImageView.frame.size.height * 0.5);
        }else{
            
            self.backGImageView.image = [[UIImage imageNamed:@"chat_receiver_bg@2x.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
            self.backGImageView.frame = CGRectMake(50, 5, self.contentLable.frame.size.width + 40, self.bounds.size.height - 10);
            
            self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            self.contentLable.center = CGPointMake(self.backGImageView.frame.size.width * 0.5, self.backGImageView.frame.size.height * 0.5);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
