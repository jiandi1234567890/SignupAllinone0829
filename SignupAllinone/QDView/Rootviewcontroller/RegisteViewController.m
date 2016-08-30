//
//  RegisteViewController.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//


#import "RegisteViewController.h"
#import "LoginRequest.h"

#define textheight 40
@interface RegisteViewController ()
{
    UITextField   *phonenumber,*passedcode,*securitycode;
    UIButton *getcodebutton;
    NSTimer *timer;
    NSInteger timecount;
    //服务器给的加密验证码
    NSString *SCodeX;
}

@end

@implementation RegisteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"用户注册";
   self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundview.jpg"]];
    
    UILabel *labelphone=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, textheight)];
    labelphone.text=@"手机号：";
    labelphone.textColor=[UIColor whiteColor];
    labelphone.textAlignment=NSTextAlignmentRight;
    phonenumber=[[UITextField alloc]init];
    phonenumber.backgroundColor=[UIColor clearColor];
    phonenumber.leftView=labelphone;
    phonenumber.leftViewMode=UITextFieldViewModeAlways;
    phonenumber.layer.borderColor=[UIColor whiteColor].CGColor;
    phonenumber.layer.borderWidth=1;
    phonenumber.layer.cornerRadius=5;
    phonenumber.layer.masksToBounds=YES;
    phonenumber.textColor=[UIColor whiteColor];
    phonenumber.placeholder=@"请输入手机号码";
    [self.view addSubview:phonenumber];
    
    UILabel *labelpassedcode=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, textheight)];
    labelpassedcode.text=@"密码：";
    labelpassedcode.textColor=[UIColor whiteColor];
    labelpassedcode.textAlignment=NSTextAlignmentRight;
    passedcode=[[UITextField alloc]init];
    passedcode.backgroundColor=[UIColor clearColor];
    passedcode.leftView=labelpassedcode;
    passedcode.secureTextEntry=YES;
    passedcode.leftViewMode=UITextFieldViewModeAlways;
    passedcode.layer.borderColor=[UIColor whiteColor].CGColor;
    passedcode.layer.borderWidth=1;
    passedcode.layer.cornerRadius=5;
    passedcode.layer.masksToBounds=YES;
    passedcode.textColor=[UIColor whiteColor];
    passedcode.placeholder=@"6-14位数字和字母";
    [self.view addSubview:passedcode];
    
    //获取验证码按钮
    getcodebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    getcodebutton.backgroundColor=[UIColor greenColor];
    [getcodebutton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getcodebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getcodebutton.titleLabel.font=[UIFont systemFontOfSize:15];
    getcodebutton.layer.cornerRadius=5;
    getcodebutton.layer.masksToBounds=YES;
    [getcodebutton addTarget:self action:@selector(getcodebuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getcodebutton];
    
    UILabel *labelgetcode=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, textheight)];
    labelgetcode.text=@"验证码：";
    labelgetcode.textColor=[UIColor whiteColor];
    labelgetcode.textAlignment=NSTextAlignmentRight;
    securitycode=[[UITextField alloc]init];
    securitycode.backgroundColor=[UIColor clearColor];
    securitycode.leftView=labelgetcode;
    securitycode.leftViewMode=UITextFieldViewModeAlways;
    securitycode.layer.borderColor=[UIColor whiteColor].CGColor;
    securitycode.layer.borderWidth=1;
    securitycode.layer.cornerRadius=5;
    securitycode.layer.masksToBounds=YES;
    securitycode.textColor=[UIColor whiteColor];
    [self.view addSubview:securitycode];
    
    //确定注册
    UIButton *surebutton=[UIButton buttonWithType:UIButtonTypeSystem];
    surebutton.backgroundColor=[UIColor orangeColor];
    [surebutton setTitle:@"确定注册" forState:UIControlStateNormal];
    [surebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    surebutton.layer.cornerRadius=5;
    surebutton.layer.masksToBounds=YES;
    [surebutton addTarget:self action:@selector(surebuttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:surebutton];
    
    phonenumber.sd_layout
    .topSpaceToView(self.view,100)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(textheight);
    
    passedcode.sd_layout
    .topSpaceToView(phonenumber,10)
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .heightIs(textheight);
    
    
    getcodebutton.sd_layout
    .topSpaceToView(passedcode,15)
    .rightSpaceToView(self.view,10)
    .heightIs(textheight)
    .widthIs(100);
    
    securitycode.sd_layout
    .topSpaceToView(passedcode,15)
    .rightSpaceToView(getcodebutton,15)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    surebutton.sd_layout
    .topSpaceToView(securitycode,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
}

#pragma mark - 获取验证码
-(void)getcodebuttonClick{
    //收起键盘
    [self.view endEditing:YES];
    
    if([NSString isMobileNumber:phonenumber.text]){
        [getcodebutton setEnabled:NO];
        [getcodebutton setTitle:@"发送中(60)" forState:UIControlStateDisabled];
        getcodebutton.backgroundColor=[UIColor grayColor];
        [loginRequest SecurityCodeRequest:phonenumber.text andStyle:@"100" andBlock:^(NSString *SecurityCodeX) {
            
            if(SecurityCodeX!=nil){
                SCodeX=SecurityCodeX;
            }else{
                [getcodebutton setEnabled:YES];
                getcodebutton.backgroundColor=[UIColor greenColor];
                [getcodebutton setTitle:@"获取验证码" forState:UIControlStateNormal];
                HUD_NAME(@"获取验证码失败，请重新获取", 0.8)
            }
        }];
        timecount=60;
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timecount) userInfo:nil repeats:YES];
        
    }else{
        HUD_NAME(@"请输入正确的手机号码！", 0.8)
    }
}

-(void)timecount{
    
    timecount--;
    
    [getcodebutton setTitle:[NSString stringWithFormat:@"发送中(%ld)",(long)timecount] forState:UIControlStateDisabled];
    
    if(timecount==0)
    {
        [timer invalidate];
        timer=nil;
        [getcodebutton setEnabled:YES];
        getcodebutton.backgroundColor=[UIColor greenColor];
        [getcodebutton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
#pragma mark - 注册帐号
-(void)surebuttonClick{
    
    if([NSString isMobileNumber:phonenumber.text]){
        
        if(passedcode.text.length>=6){
            
            if(securitycode.text.length==4){
                
                [loginRequest RegisterRequest:phonenumber.text andPass:passedcode.text andSecurityCode:securitycode.text andSecurityCodeX:SCodeX andBlock:^(NSDictionary *dic) {
                    
                NSString * loginstatus= [NSString stringWithFormat:@"%@", [dic objectForKey:@"error_code"] ];
                    NSString *repeatregiste=[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]];
                    NSLog(@"dic:%@",dic);
                    if([loginstatus isEqualToString:@"0"]){
                        __block  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hud.label.text=@"登录中";
                        hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
                        hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:.6f];
                        
                        [loginRequest LoginRequest:phonenumber.text andPass:passedcode.text andBlock:^(NSString *string) {
                            
                            if([string isEqualToString:@"0"]){
                                
                                [[NSUserDefaults standardUserDefaults]setObject:phonenumber.text forKey:@"TheLoginname"];
                                
                                [[NSUserDefaults standardUserDefaults]setObject:passedcode.text forKey:@"TheLoginpassedcode"];
                                [hud hideAnimated:YES];
                                
                                //ViewController * vc =[[ViewController alloc]init];
                                ChangenameViewController *vc=[[ChangenameViewController alloc]init];
                                UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:vc];
                                
                                [self presentViewController:nav animated:YES completion:nil];
                               // [self.navigationController pushViewController:nav animated:YES];
                                
                            }else{
                                [hud hideAnimated:YES];
                                HUD_NAME(@"账户或密码错误！", 1)
                            }
                            
                        }];
                    }else if([repeatregiste isEqualToString:@"该手机号已被注册"]){
                        
                        HUD_NAME(@"该手机号已被注册！若忘记密码请用找回密码功能！", 0.8)
                    }else{
                        HUD_NAME(@"注册失败，请重新获取验证码！", 0.8)
                    }
                }];
            }else{
                HUD_NAME(@"验证码格式错误！", 0.8)
            }
        }else{
            HUD_NAME(@"密码长度过短！", 0.8)
        }
    }else{
        HUD_NAME(@"请输入正确的手机号码！", 0.8)
    }
}
@end
