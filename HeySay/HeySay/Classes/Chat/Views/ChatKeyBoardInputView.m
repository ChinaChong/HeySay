//
//  ChatKeyBoardInputView.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "ChatKeyBoardInputView.h"


@interface ChatKeyBoardInputView ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *textField;

@end

@implementation ChatKeyBoardInputView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(kMargin, kMargin, ScreenWidth - 100 - kMargin, NormalHeight - 2 * kMargin)];
        self.textField.placeholder = @"说点什么吧...";
        self.textField.backgroundColor = [UIColor lightGrayColor];
        self.textField.layer.cornerRadius = 4;
        self.textField.layer.masksToBounds = YES;
        self.textField.font = [UIFont systemFontOfSize:14];
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        UIButton *sendBtn= [UIButton buttonWithType:(UIButtonTypeSystem)];
        sendBtn.backgroundColor = [UIColor magentaColor];
        sendBtn.layer.cornerRadius = 4;
        sendBtn.layer.masksToBounds = YES;
        sendBtn.frame = CGRectMake(CGRectGetMaxX(self.textField.frame) + 8, kMargin, ScreenWidth - CGRectGetWidth(self.textField.frame) - 3 * kMargin, NormalHeight - 2 * kMargin);
        [sendBtn setTitle:@"发送" forState:(UIControlStateNormal)];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [self addSubview:sendBtn];
        [sendBtn addTarget:self action:@selector(sendMessage:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return self;
}

- (void)sendMessage:(UIButton *)sender {
    
    NSString *text = self.textField.text;
    
    if (text.length > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatViewSendMessageButtonClick object:text];
        
        self.textField.text = @"";
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.textField resignFirstResponder];
    
    return YES;
}



@end
