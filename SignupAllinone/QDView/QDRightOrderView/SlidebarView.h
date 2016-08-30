//
//  SlidebarView.h
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChangenameViewController.h"
#import "SigninViewController.h"
#import "CountTimeViewController.h"
#import "RootViewController.h"

typedef void(^slideBlock) ();

@interface SlidebarView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSArray * _orderArr;//菜单列表
}

@property(nonatomic,strong) UITableView * mytableview;
@property (nonatomic,strong) id myDelegate;
@property(nonatomic,copy) slideBlock  signBlock;
@property(nonatomic,copy) slideBlock  memberBlock;
@property(nonatomic,copy) slideBlock  timeBlock;
@property(nonatomic,copy) slideBlock  signoutBlock;
@property(nonatomic,copy) slideBlock  changecodeBlock;
@end


















