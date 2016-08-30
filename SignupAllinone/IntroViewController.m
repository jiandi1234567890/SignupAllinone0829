//
//  IntroViewController.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/6/30.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "IntroViewController.h"
#import "UIView+SDAutoLayout.h"
#import "ViewController.h"
#import "ChangenameViewController.h"

@interface IntroViewController ()

@end



@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundview.jpg"]];
    [self initGuide];
}


-(void)initGuide{
    
    UILabel *labelwelcom=[[UILabel alloc]init];
    labelwelcom.textAlignment=NSTextAlignmentCenter;
    labelwelcom.text=@"欢迎使用广为签到APP";
    labelwelcom.font=[UIFont boldSystemFontOfSize:26];
    labelwelcom.textColor=[UIColor whiteColor];
    [self.view addSubview:labelwelcom];
    
    UILabel *labelintro=[[UILabel alloc]init];
    labelintro.textColor=[UIColor whiteColor];
    labelintro.numberOfLines=0;
    labelintro.text=@"以下为使用注意事项：\n1、多账号需切换账号时，请点击“主页”经行切换\n2、若贴吧列表未显示请点击“刷新”按钮\n3、点击贴吧列表为单个贴吧签到\n4、在使用多账户一键签到时，保证所有账号下的本地贴吧列表不为空(若为空请切换到对应贴吧账号下刷新贴吧列表)，避免程序闪退";
    [self.view addSubview:labelintro];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"知道了" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderWidth=1;
    button.layer.borderColor=[UIColor whiteColor].CGColor;
    button.layer.cornerRadius=8;
    button.layer.masksToBounds=YES;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];


    labelwelcom.sd_layout
    .topSpaceToView(self.view,30)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .heightIs(80);
    
    labelintro.sd_layout
    .topSpaceToView(labelwelcom,30)
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .heightIs(240);
    
    button.sd_layout
    .topSpaceToView(labelintro,20)
    .centerXEqualToView(self.view)
    .widthIs(80)
    .heightIs(50);
    
}





-(void)buttonClick{
    //ViewController * vc =[[ViewController alloc]init];
    ChangenameViewController *vc=[[ChangenameViewController alloc]init];
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];

    
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
