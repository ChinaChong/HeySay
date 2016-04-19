//
//  DeviceDelegateHelper.h
//  RongTest
//
//  Created by pintukeji on 15/12/22.
//  Copyright © 2015年 pintutech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDeviceHeaders.h"
#import "AppDelegate.h"
#define KNOTIFICATION_onCallEvent    @"KNOTIFICATION_onCallEvent"

#define KNOTIFICATION_onConnected       @"KNOTIFICATION_onConnected"

#define KNOTIFICATION_onNetworkChanged    @"KNOTIFICATION_onNetworkChanged"

#define KNOTIFICATION_onSystemEvent    @"KNOTIFICATION_onSystemEvent"

#define KNOTIFICATION_onMesssageChanged    @"KNOTIFICATION_onMesssageChanged"

#define KNOTIFICATION_onRecordingAmplitude    @"KNOTIFICATION_onRecordingAmplitude"

#define KNOTIFICATION_onReceivedGroupNotice    @"KNOTIFICATION_onReceivedGroupNotice"

#define KNOTIFICATION_haveHistoryMessage @"KNOTIFICATION_haveHistoryMessage"
#define KNOTIFICATION_HistoryMessageCompletion @"KNOTIFICATION_HistoryMessageCompletion"

#define KNOTIFICATION_needInputName @"KNOTIFICATION_needInputName"
@interface DeviceDelegateHelper : NSObject<ECDeviceDelegate>
/**
 
 *@brief 获取DeviceDelegateHelper单例句柄
 
 */
+(DeviceDelegateHelper*)sharedInstance;
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, strong) NSDate* preDate;
@property (nonatomic, assign) BOOL isB2F;
@end
