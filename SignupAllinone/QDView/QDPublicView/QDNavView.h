//
//  QDNavView.h
//  GWSignIn
//
//  Created by 广为网络 on 16/4/14.
//  Copyright © 2016年 广为网络. All rights reserved.
//
//导航背景颜色
#define NAV_BG_OLOR [UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00]
//导航字颜色
#define NAV_NAME_OLOR [UIColor whiteColor]

#define PX [[UIScreen mainScreen] bounds].size.width
#import <UIKit/UIKit.h>

@interface QDNavView : UIView
//标题
- (void)navTitleName:(NSString *)titleStr andBtnAdd:(SEL)TitleButton;
- (void)navTitleName:(NSString *)titleStr;
- (void)navTitleView:(UIView *)titleView;
//右边按钮
- (void)navRightBtn:(NSString *)btnStr andBtnAdd:(SEL)rightButton;
- (void)navRightBtnimage:(UIImage *)image andBtnAdd:(SEL)rightButton;
- (void)navLeftBtnimage:(UIImage *)image andBtnAdd:(SEL)rightButton;

@end
