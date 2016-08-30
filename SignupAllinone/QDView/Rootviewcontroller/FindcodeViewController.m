//
//  FindcodeViewController.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "FindcodeViewController.h"
#import "loginRequest.h"

#define textheight 40
@interface FindcodeViewController ()
{
    UITextField *phonenumber,*newcode,*requirecode,*securitycode;
    UIButton *getsecuritycode;
    NSTimer *timer;
    NSInteger timecount;
    //服务器给的加密验证码
    NSString *SCodeX;
}

@end

@implementation FindcodeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"找回密码";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundview.jpg"]];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label1.text=@"用户账号：";
    label1.textColor=[UIColor whiteColor];
    label1.textAlignment=NSTextAlignmentRight;
    phonenumber=[[UITextField alloc]init];
    phonenumber.textColor=[UIColor whiteColor];
    phonenumber.backgroundColor=[UIColor clearColor];
    phonenumber.leftView=label1;
    phonenumber.leftViewMode=UITextFieldViewModeAlways;
    phonenumber.placeholder=@"请输入账户名";
    UILabel *labelline1=[[UILabel alloc]init];
    labelline1.backgroundColor=[UIColor whiteColor];
    [phonenumber addSubview:labelline1];
    [self.view addSubview:phonenumber];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label2.text=@"新密码：";
    label2.textColor=[UIColor whiteColor];
    label2.textAlignment=NSTextAlignmentRight;
    newcode=[[UITextField alloc]init];
    newcode.leftView=label2;
    newcode.backgroundColor =[UIColor clearColor];
    newcode.leftViewMode=UITextFieldViewModeAlways;
    newcode.textColor=[UIColor whiteColor];
    newcode.secureTextEntry=YES;
    newcode.layer.masksToBounds=YES;
    newcode.placeholder=@"请输入新密码";
    
    UILabel *labelline2=[[UILabel alloc]init];
    labelline2.backgroundColor=[UIColor whiteColor];
    [newcode addSubview:labelline2];
    [self.view addSubview:newcode];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label3.text=@"确认密码：";
    label3.textColor=[UIColor whiteColor];
    label3.textAlignment=NSTextAlignmentRight;
    requirecode=[[UITextField alloc]init];
    requirecode.leftView=label3;
    requirecode.leftViewMode=UITextFieldViewModeAlways;
    requirecode.backgroundColor=[UIColor clearColor];
    requirecode.textColor=[UIColor whiteColor];
    requirecode.placeholder=@"请再次输入新密码";
    requirecode.secureTextEntry=YES;
    UILabel *labelline3=[[UILabel alloc]init];
    labelline3.backgroundColor=[UIColor whiteColor];
    [requirecode addSubview:labelline3];
    [self.view addSubview:requirecode];
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label4.text=@"验证码：";
    label4.textColor=[UIColor whiteColor];
    label4.textAlignment=NSTextAlignmentRight;
    securitycode=[[UITextField alloc]init];
    securitycode.leftView=label4;
    securitycode.leftViewMode=UITextFieldViewModeAlways;
    securitycode.backgroundColor=[UIColor clearColor];
    securitycode.textColor=[UIColor whiteColor];
    securitycode.placeholder=@"请输入验证码";
    UILabel *labelline4=[[UILabel alloc]init];
    labelline4.backgroundColor=[UIColor whiteColor];
    [securitycode addSubview:labelline4];
    [self.view addSubview:securitycode];
    
    //获取验证码按键
    getsecuritycode=[UIButton buttonWithType:UIButtonTypeCustom];
    [getsecuritycode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getsecuritycode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getsecuritycode.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    getsecuritycode.backgroundColor=[UIColor greenColor];
    getsecuritycode.layer.cornerRadius=5;
    getsecuritycode.layer.masksToBounds=YES;
    [getsecuritycode addTarget:self action:@selector(getSecuritycodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getsecuritycode];
    
    //确认修改密码按键
    UIButton *comfirmation=[UIButton buttonWithType:UIButtonTypeSystem];
    [comfirmation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmation setTitle:@"确认修改" forState:UIControlStateNormal];
    comfirmation.backgroundColor=[UIColor orangeColor];
    comfirmation.layer.cornerRadius=8;
    comfirmation.layer.masksToBounds=YES;
    [comfirmation addTarget:self action:@selector(confirmatianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirmation];
    
    phonenumber.sd_layout
    .topSpaceToView(self.view,100)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    labelline1.sd_layout
    .bottomSpaceToView(phonenumber,1)
    .leftEqualToView(phonenumber)
    .rightEqualToView(phonenumber)
    .heightIs(1);
    
    newcode.sd_layout
    .topSpaceToView(phonenumber,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    labelline2.sd_layout
    .bottomSpaceToView(newcode,1)
    .leftEqualToView(newcode)
    .rightEqualToView(newcode)
    .heightIs(1);
    
    requirecode.sd_layout
    .topSpaceToView(newcode,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    labelline3.sd_layout
    .bottomSpaceToView(requirecode,1)
    .rightEqualToView(requirecode)
    .leftEqualToView(requirecode)
    .heightIs(1);
    
    securitycode.sd_layout
    .topSpaceToView(requirecode,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    labelline4.sd_layout
    .bottomSpaceToView(securitycode,1)
    .leftEqualToView(securitycode)
    .rightEqualToView(securitycode)
    .heightIs(1);
    
    getsecuritycode.sd_layout
    .topSpaceToView(securitycode,-textheight)
    .bottomSpaceToView(securitycode,-(textheight-10))
    .rightSpaceToView(self.view,12)
    .widthIs(85);
    
    comfirmation.sd_layout
    .topSpaceToView(securitycode,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
}

#pragma mark - 获取验证码
-(void)getSecuritycodeClick{
    if([NSString isMobileNumber:phonenumber.text]){
        [getsecuritycode setEnabled:NO];
        [getsecuritycode setTitle:@"发送中(60)" forState:UIControlStateDisabled];
        getsecuritycode.backgroundColor=[UIColor grayColor];
        
        [loginRequest SecurityCodeRequest:phonenumber.text andStyle:@"200" andBlock:^(NSString *SecurityCodeX) {
            
            if(SecurityCodeX!=nil){
                SCodeX=SecurityCodeX;
                
            }else{
                [getsecuritycode setEnabled:YES];
                getsecuritycode.backgroundColor=[UIColor greenColor];
                [getsecuritycode setTitle:@"获取验证码" forState:UIControlStateNormal];
                HUD_NAME(@"获取验证码失败，请重新获取", 0.8)
            }
            
        }];
        timecount=60;
        timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timecount) userInfo:nil repeats:YES];
    }else{
        HUD_NAME(@"请输入正确的手机号码！", 0.8)
    }

}
- (void)timecount{
    timecount--;
    
    [getsecuritycode setTitle:[NSString stringWithFormat:@"发送中(%ld)",(long)timecount] forState:UIControlStateDisabled];
    
    if(timecount==0)
    {
        [timer invalidate];
        timer=nil;
        [getsecuritycode setEnabled:YES];
        getsecuritycode.backgroundColor=[UIColor greenColor];
        [getsecuritycode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}
#pragma mark - 找回密码
- (void)confirmatianBtnClick
{
    if (![newcode.text isEqualToString:requirecode.text]) {
        HUD_NAME(@"两次密码不一致", 0.8)
        return;
    }
    if (securitycode.text.length<4) {
        HUD_NAME(@"请正确的输入验证码", 0.8)
        return;
    }
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:phonenumber.text,@"phone",SCodeX,@"revsesid",requirecode.text,@"password",securitycode.text,@"vcode", nil];;
    [loginRequest FindBackRequest:dic andBlock:^(NSString *string) {
        if ([string isEqualToString:@"0"]) {
            HUD_NAME(@"找回密码成功，请用新密码登录！", 0.95);
            [self performSelector:@selector(selfpop) withObject:nil afterDelay:1.0f];
            
        }else
        {
            HUD_NAME(@"验证码错误", 0.8)
        }
    }];
}


-(void)selfpop{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
