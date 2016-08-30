//
//  AppDelegate.m
//  SignupAllinone
//
//  Created by 广为网络 on 16/6/17.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"
#import "IntroViewController.h"
#import "AFNetworking.h"
#import "LeftSortsViewController.h"
#import "RunInBackground.h"


@interface AppDelegate ()
{
    BOOL _holding;
}
@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) NSTimer *myTimer;
@property(nonatomic,strong) NSThread * thread;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
      IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    // [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"netstatus"];
        //开始监察网络状态
        [[AFNetworkReachabilityManager sharedManager]startMonitoring];
        //如果网络发送变化
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if (status == AFNetworkReachabilityStatusNotReachable)
            {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"netstatus"];
                //HUD_NAME(@"没有网络，请检查！", 2.5)
            }else
            {
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"netstatus"];
            }
        }];
   

//    //转态字变白色
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //if([[NSUserDefaults standardUserDefaults]stringForKey:@"TheLoginname"]!=nil){
       LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
         MainViewController *vc=[[MainViewController alloc]init];
        self.mainVC =[[UINavigationController alloc] initWithRootViewController:vc];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainVC];
        [self.LeftSlideVC setPanEnabled:YES];
        self.window.rootViewController = self.LeftSlideVC;
        

//        
//    }else {
//        RootViewController * vc =[[RootViewController alloc]init];
//        UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:vc];
//        self.window.rootViewController = nav;
//    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   NSLog(@"enterBG");
    NSLog(@"===额外申请的后台任务时间为: %f===",application.backgroundTimeRemaining);
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
       
        UIApplication *application = [UIApplication sharedApplication];
        __block UIBackgroundTaskIdentifier background_task;
        //Create a task object
        background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
            _holding = YES;
            while (_holding) {
                [NSThread sleepForTimeInterval:1];
                /** clean the runloop for other source */
                
                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, TRUE);
 
                        }
            [application endBackgroundTask: background_task];
            background_task = UIBackgroundTaskInvalid;
        }];
    }
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//         _holding = YES;
//        [[RunInBackground sharedBg] startRunInbackGround];
//        [[NSRunLoop currentRunLoop] run];
//        self.thread = [NSThread currentThread];
//    });


 }



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ( _holding) {
        [[RunInBackground sharedBg] stopAudioPlay];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
