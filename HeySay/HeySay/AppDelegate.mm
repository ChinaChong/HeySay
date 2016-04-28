//
//  AppDelegate.m
//  HeySay
//
//  Created by ChinaChong on 16/4/18.
//  Copyright © 2016年 ChinaChong. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self.window makeKeyAndVisible];
    
    //设置一个图片;
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];

    niceView.image = [UIImage imageNamed:@"pic-5285-9-1080x1920.jpg"];
    
    //添加到场景
    [self.window addSubview:niceView];
    
    UIImageView *niceView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight)];
    
    niceView2.image = [UIImage imageNamed:@"10279353.jpg"];
    
    //添加到场景
    [self.window addSubview:niceView2];
    [self.window bringSubviewToFront:niceView2];
    
    //放到最顶层;
    [self.window bringSubviewToFront:niceView];
    
    [UIView animateWithDuration:1.0 animations:^{
        niceView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            niceView2.alpha = 0.0;
        }];
    }];
    
    [ECDevice sharedInstance].delegate = [DeviceDelegateHelper sharedInstance];
    
    NSString *APPID = @"9sO2iepe985cP4taIcK2vOcV-gzGzoHsz";
    NSString *APPKey = @"dczCCipmU5bBtLd7Bm2owS8q";
    
    // applicationId 即 App Id，clientKey 是 App Key。
    [AVOSCloud setApplicationId:APPID clientKey:APPKey];
    
    // 如果想跟踪统计应用的打开情况，后面还可以添加下列代码：
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    return YES;
}

- (void)animationStart:(UIImageView *)imageView {
    
    
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    //    這裡還可以設置回調函數;
    
    //    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
    
    imageView.alpha = 0.0;
    imageView.frame = CGRectMake(0, 0, ScreenWidth * 1.1, ScreenHeight * 1.1);
    imageView.center = self.window.center;
    [UIView commitAnimations];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
