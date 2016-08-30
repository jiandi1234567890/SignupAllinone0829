//
//  RootViewController.m
//  weika
//
//  Created by 张海禄 on 16/6/10.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "RootViewController.h"
#import "RegisteViewController.h"
#import "FindcodeViewController.h"
#import "LoginRequest.h"
#import "ViewController.h"
#import "IntroViewController.h"
#import "ChangenameViewController.h"

#define textheight 40
@interface RootViewController ()

@end

@implementation RootViewController
{
    UITextField *TFname,*TFcode;
}

-(void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"用户登录";
    
    //设置字体为白色
    self.navigationController.navigationBar.titleTextAttributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    //设置背景为蓝色
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.37 green:0.64 blue:0.91 alpha:1.00];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundview.jpg"]];
    
    [self LoginIn];
}

//登录界面
-(void)LoginIn{
    
    //更改返回键样式
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    //头像
    UIImageView *headview=[[UIImageView alloc]init];
    headview.image=[UIImage imageNamed:@"icon.png"];
    headview.layer.cornerRadius=50;
    headview.layer.masksToBounds=YES;
    
    //账户
    UILabel *labelname=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, textheight)];
    labelname.text=@"账户：";
    labelname.textColor=[UIColor whiteColor];
    labelname.textAlignment=NSTextAlignmentRight;
    TFname=[[UITextField alloc]init];
    TFname.backgroundColor=[UIColor clearColor];
    TFname.textColor=[UIColor whiteColor];
    TFname.leftView=labelname;
    TFname.leftViewMode=UITextFieldViewModeAlways;
    TFname.placeholder=@"请输入账号";
    UILabel *labelline1=[[UILabel alloc]init];
    labelline1.backgroundColor=[UIColor whiteColor];
    [TFname addSubview:labelline1];

    
    //密码
    UILabel *labelcode=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, textheight)];
    labelcode.text=@"密码：";
    labelcode.textColor=[UIColor whiteColor];
    labelcode.textAlignment=NSTextAlignmentRight;
    TFcode=[[UITextField alloc]init];
    TFcode.backgroundColor=[UIColor clearColor];
    TFcode.textColor=[UIColor whiteColor];
    TFcode.leftView=labelcode;
    TFcode.leftViewMode=UITextFieldViewModeAlways;
    TFcode.secureTextEntry=YES;
    TFcode.placeholder=@"请输入密码";
    UILabel *labelline2=[[UILabel alloc]init];
    labelline2.backgroundColor=[UIColor whiteColor];
    [TFcode addSubview:labelline2];

    
    
    //没账号马上注册按键
    NSString *string1=@"注册账号";
    NSString *string2=@"忘记密码？";
    //获取字符串长度
    CGSize button1size=[string1 boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    CGSize button2size=[string2  boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    
    //注册按键
    UIButton *registerbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    registerbutton.titleLabel.font=[UIFont systemFontOfSize:16];
    
    //按键点中添加下滑线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"注册账号" ];
    NSMutableAttributedString *str1 =[[NSMutableAttributedString alloc] initWithString:@"注册账号" ];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    //给文字添加颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:strRange];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange];
    [registerbutton setAttributedTitle:str forState:UIControlStateHighlighted];
    [registerbutton setAttributedTitle:str1 forState:UIControlStateNormal];
    [registerbutton addTarget:self action:@selector(registerbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //忘记密码按键
    UIButton  *findcodebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    NSMutableAttributedString *str2=[[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
    NSMutableAttributedString *str3 =[[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
    NSRange strRange1 = {0,[str2 length]};
    [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange1];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:strRange1];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:strRange1];
    [findcodebutton setAttributedTitle:str2 forState:UIControlStateHighlighted];
    [findcodebutton setAttributedTitle:str3 forState:UIControlStateNormal];
    findcodebutton.titleLabel.font=[UIFont systemFontOfSize:16];
    [findcodebutton addTarget:self action:@selector(findcodebuttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //登录按键
    UIButton *loginBTN=[UIButton buttonWithType:UIButtonTypeSystem];
    loginBTN.backgroundColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
    [loginBTN setTitle:@"登录" forState:UIControlStateNormal];
    loginBTN.titleLabel.font=[UIFont systemFontOfSize:18];
    [loginBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBTN.layer.cornerRadius=5;
    loginBTN.layer.masksToBounds=YES;
    [loginBTN addTarget:self action:@selector(loginbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:headview];
    [self.view addSubview:TFname];
    [self.view addSubview:TFcode];
    [self.view addSubview:registerbutton];
    [self.view addSubview:findcodebutton];
    [self.view addSubview:loginBTN];
#pragma mark -- 控件约束
    
    headview.sd_layout
    .topSpaceToView(self.view,90)
    .leftSpaceToView(self.view,self.view.centerX-50)
    .widthIs(100)
    .heightIs(100);
    
    TFname.sd_layout
    .topSpaceToView(headview,30)
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .heightIs(textheight);
    
    labelline1.sd_layout
    .bottomSpaceToView(TFname,1)
    .leftEqualToView(TFname)
    .rightEqualToView(TFname)
    .heightIs(1);
    
    TFcode.sd_layout
    .topSpaceToView(TFname,15)
    .leftEqualToView(TFname)
    .rightEqualToView(TFname)
    .heightIs(textheight);
    
    labelline2.sd_layout
    .bottomSpaceToView(TFcode,1)
    .leftEqualToView(TFcode)
    .rightEqualToView(TFcode)
    .heightIs(1);
    
    loginBTN.sd_layout
    .topSpaceToView(TFcode,35)
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .heightIs(45);
    
    
    registerbutton.sd_layout
    .topSpaceToView(loginBTN,30)
    .leftEqualToView(TFcode)
    .widthIs(button1size.width)
    .heightIs(button1size.height);
    
    findcodebutton.sd_layout
    .topEqualToView(registerbutton)
    .rightEqualToView(TFcode)
    .widthIs(button2size.width)
    .heightIs(button2size.height);

}

#pragma mark - 登录中
-(void)loginbuttonClick{
    
    [self.view endEditing:YES];
    
    if(TFname.text.length>9&&TFcode.text.length>5){
        __block  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text=@"登录中";
        hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:.6f];
        [loginRequest LoginRequest:TFname.text andPass:TFcode.text andBlock:^(NSString *string) {
            if([string isEqualToString:@"0"]){
                [[NSUserDefaults standardUserDefaults]setObject:TFname.text forKey:@"TheLoginname"];
                
                [[NSUserDefaults standardUserDefaults]setObject:TFcode.text forKey:@"TheLoginpassedcode"];
                
                [hud hideAnimated:YES];
                
                
//                if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
//                {
//                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//                    IntroViewController *introVC=[[IntroViewController alloc]init];
//                    [self presentViewController:introVC animated:YES completion:nil];
//                    
//                }else{
                    AppDelegate *delegate=(AppDelegate *)[[UIApplication  sharedApplication] delegate];
                    
                    ChangenameViewController *vc=[[ChangenameViewController alloc]init];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [delegate.mainVC pushViewController:vc animated:YES];
                                       
               // }

            
                
            }else{
                [hud hideAnimated:YES];
                HUD_NAME(@"账户或密码错误！", 1)
            }
        }];
    }else{
        HUD_NAME(@"账户或密码格式不正确！", 0.8)
    }
}
//跳转注册
-(void)registerbuttonClick{
    
    RegisteViewController *registeVC=[[RegisteViewController alloc]init];
    self.navigationController.navigationBar.hidden=NO;
    [self.navigationController pushViewController:registeVC animated:YES];
    
}
//跳转找回密码
-(void)findcodebuttonClick{
    
    FindcodeViewController *findcodeVC=[[FindcodeViewController alloc]init];
     self.navigationController.navigationBar.hidden=NO;
    [self.navigationController pushViewController:findcodeVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
