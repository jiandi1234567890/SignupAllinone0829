//
//  InstructionsViewController.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/18.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title=@"使用说明";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:self.view.frame];
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.font=[UIFont boldSystemFontOfSize:18];
    label.text=@"1、点击主页'添加账号'登录百度账号,点击账号后为该账号下具体贴吧列表，点击可签到单个贴吧!\n2、主页一键签到默认为签到所有账户里的贴吧（设置侧栏里可设置哪些账户不签到）\n3、设置侧栏的开启方式可以点击'设置开启'，也可在主页向左滑开启\4、注册广为账号后能获取更多账号管理服务";
    
    
    [self.view addSubview:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
