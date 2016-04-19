//
//  DeviceDelegateHelper.m
//  RongTest
//
//  Created by pintukeji on 15/12/22.
//  Copyright © 2015年 pintutech. All rights reserved.
//

#import "DeviceDelegateHelper.h"


@implementation DeviceDelegateHelper

+(DeviceDelegateHelper*)sharedInstance

{
    
    static DeviceDelegateHelper *devicedelegatehelper;
    
    static dispatch_once_t devicedelegatehelperonce;
    
    dispatch_once(&devicedelegatehelperonce, ^{
        
        devicedelegatehelper = [[DeviceDelegateHelper alloc] init];
        
    });
    
    return devicedelegatehelper;
    
}

//第二步：连接云通讯的服务平台，实现ECDelegateBase代理的方法

/**
 
 @brief 连接状态接口
 
 @discussion 监听与服务器的连接状态 V5.0版本接口
 
 @param state 连接的状态
 
 @param error 错误原因值
 
 */

-(void)onConnectState:(ECConnectState)state failed:(ECError*)error {
    
    switch (state) {
            
        case State_ConnectSuccess://连接成功
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_NoError]];
            
            break;
            
        case State_Connecting://正在连接
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:[ECError errorWithCode:ECErrorType_Connecting]];
            
            break;
            
        case State_ConnectFailed://失败
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onConnected object:error];
            
            break;
            
        default:
            
            break;
            
    }
    
}

//第三步 ：各功能回调函数实现

//1. 如需使用im功能，需实现ECChatDelegate类的回调函数。

/**
 
 @brief 客户端录音振幅代理函数
 
 @param amplitude 录音振幅
 
 */

-(void)onRecordingAmplitude:(double) amplitude {
    
}



/**
 
 @brief 接收即时消息代理函数
 
 @param message 接收的消息
 
 */

-(void)onReceiveMessage:(ECMessage*)message {
    
    switch(message.messageBody.messageBodyType){
        case MessageBodyType_Text:{
            ECTextMessageBody *msgBody = (ECTextMessageBody *)message.messageBody;
            NSLog(@"收到的是文本消息------%@",msgBody.text);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:message];
            
            break;
        }
        case MessageBodyType_Voice:{
            ECVoiceMessageBody *msgBody = (ECVoiceMessageBody *)message.messageBody;
            NSLog(@"音频文件remote路径------%@",msgBody. remotePath);
            break;
        }
            
        case MessageBodyType_Video:{
            ECVideoMessageBody *msgBody = (ECVideoMessageBody *)message.messageBody;
            NSLog(@"视频文件remote路径------%@",msgBody. remotePath);
            break;
        }
            
        case MessageBodyType_Image:{
            ECImageMessageBody *msgBody = (ECImageMessageBody *)message.messageBody;
            NSLog(@"图片文件remote路径------%@",msgBody. remotePath);
            NSLog(@"缩略图片文件remote路径------%@",msgBody. thumbnailRemotePath);
            break;
        }
            
        case MessageBodyType_File:{
            ECFileMessageBody *msgBody = (ECFileMessageBody *)message.messageBody;
            NSLog(@"文件remote路径------%@",msgBody. remotePath);
            break;
        }
        default:
            break;
    }
}



/**
 
 @brief 离线消息数
 
 @param count 消息数
 
 */

-(void)onOfflineMessageCount:(NSUInteger)count {
    
}



/**
 
 @brief 需要获取的消息数
 
 @return 消息数 -1:全部获取 0:不获取
 
 */

//-(NSInteger)onGetOfflineMessage {
//    
//}



/**
 
 @brief 接收离线消息代理函数
 
 @param message 接收的消息
 
 */

-(void)onReceiveOfflineMessage:(ECMessage*)message {
    
}



/**
 
 @brief 离线消息接收是否完成
 
 @param isCompletion YES:拉取完成 NO:拉取未完成(拉取消息失败)
 
 */

-(void)onReceiveOfflineCompletion:(BOOL)isCompletion {
    
}

/**
 
 @brief 接收群组相关消息
 
 @discussion 参数要根据消息的类型，转成相关的消息类；
 
 解散群组、收到邀请、申请加入、退出群组、有人加入、移除成员等消息
 
 @param groupMsg 群组消息
 
 */

-(void)onReceiveGroupNoticeMessage:(ECGroupNoticeMessage *)groupMsg {
    
}



//2.如需使用音视频通话功能，需实现ECVoIPCallDelegate类的回调函数。

/**
 
 @brief 有呼叫进入
 
 @param callid      会话id
 
 @param caller      呼叫人
 
 @param callerphone 被叫人手机号
 
 @param callername  被叫人姓名
 
 @param calltype    呼叫类型
 
 */

//- (NSString*)onIncomingCallReceived:(NSString*)callid withCallerAccount:(NSString *)caller withCallerPhone:(NSString *)callerphone withCallerName:(NSString *)callername withCallType:(CallType)calltype {
//    
//}



/**
 
 @brief 呼叫事件
 
 @param voipCall VoIP电话实体类的对象
 
 */

- (void)onCallEvents:(VoIPCall*)voipCall {
    
}



/**
 
 @brief 收到dtmf
 
 @param callid 会话id
 
 @param dtmf   键值
 
 */

//- (void)onReceiveFrom:(NSString*)callid DTMF:(NSString*)dtmf {

//}



/**
 
 @brief 视频分辨率发生改变
 
 @param callid       会话id
 
 @param voip         VoIP号
 
 @param isConference NO 不是, YES 是
 
 @param width        宽度
 
 @param height       高度
 
 */

//- (void)onCallVideoRatioChanged:(NSString *)callid andVoIP:(NSString *)voip andIsConfrence:(BOOL)isConference andWidth:(NSInteger)width andHeight:(NSInteger)height {

//}



/**
 
 @brief 收到对方切换音视频的请求
 
 @param callid  会话id
 
 @param requestType 请求音视频类型 视频:需要响应 音频:请求删除视频（不需要响应，双方自动去除视频）
 
 */

//- (void)onSwitchCallMediaTypeRequest:(NSString *)callid withMediaType:(CallType)requestType;



/**
 
 @brief 收到对方应答切换音视频请求
 
 @param callid   会话id
 
 @param responseType 回复音视频类型
 
 */

//- (void)onSwitchCallMediaTypeResponse:(NSString *)callid withMediaType:(CallType)responseType;
//
//
//
//3.如需使用音视频会议功能，需实现ECMeetingDelegate类的回调函数。

/**
 
 @brief 实时对讲通知消息
 
 @param msg 实时对讲消息
 
 */

//-(void)onReceiveInterphoneMeetingMsg:(ECInterphoneMeetingMsg *)msg;



/**
 
 @brief 语音群聊通知消息
 
 @param msg 语音群聊消息
 
 */

//-(void)onReceiveMultiVoiceMeetingMsg:(ECMultiVoiceMeetingMsg *)msg {

//}



//多路视频通知消息

//-(void)onReceiveMultiVideoMeetingMsg:(ECMultiVideoMeetingMsg *)msg;



//有会议呼叫邀请。邀请用户（VoIP）时，呼叫回调接口，与点对点外呼接口不一致，只有会议邀请VoIP才会回调这个接口，其他情况均使用点对点呼叫回调接口

//-(NSString*)onMeetingCallReceived:(NSString*)callid withCallType:(CallType)calltype withMeetingData:(NSDictionary*)meetingData;



@end


