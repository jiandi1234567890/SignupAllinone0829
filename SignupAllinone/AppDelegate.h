//
//  AppDelegate.h
//  SignupAllinone
//
//  Created by 广为网络 on 16/6/17.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
#import "MainViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property(nonatomic,strong) UINavigationController * mainVC;


@end

