//
//  ChangecodeViewController.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/6/21.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "ChangecodeViewController.h"
#import "UIView+SDAutoLayout.h"
#import "RootViewController.h"
#import "loginRequest.h"

#define textheight 40

@interface ChangecodeViewController ()
{
    UITextField *phonenumber,*newcode,*requirecode;
}
@end

@implementation ChangecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"修改密码";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label1.text=@"用户账号：";
    label1.textAlignment=NSTextAlignmentRight;
    phonenumber=[[UITextField alloc]init];
    phonenumber.backgroundColor=[UIColor whiteColor];
    phonenumber.leftView=label1;
    phonenumber.leftViewMode=UITextFieldViewModeAlways;
    phonenumber.layer.borderColor=[UIColor blackColor].CGColor;
    phonenumber.layer.borderWidth=1;
    phonenumber.layer.cornerRadius=5;
    phonenumber.layer.masksToBounds=YES;
    phonenumber.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"TheLoginname"];
    //设置不可编辑
    phonenumber.userInteractionEnabled=NO;
    [self.view addSubview:phonenumber];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label2.text=@"旧密码：";
    label2.textAlignment=NSTextAlignmentRight;
    newcode=[[UITextField alloc]init];
    newcode.leftView=label2;
    newcode.backgroundColor =[UIColor whiteColor];
    newcode.leftViewMode=UITextFieldViewModeAlways;
    newcode.layer.borderColor=[UIColor blackColor].CGColor;
    newcode.layer.borderWidth=1;
    newcode.layer.cornerRadius=5;
    newcode.layer.masksToBounds=YES;
    newcode.placeholder=@"请输入旧密码";
    newcode.secureTextEntry=YES;
    [self.view addSubview:newcode];
    
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, textheight)];
    label3.text=@"新密码：";
    label3.textAlignment=NSTextAlignmentRight;
    requirecode=[[UITextField alloc]init];
    requirecode.leftView=label3;
    requirecode.leftViewMode=UITextFieldViewModeAlways;
    requirecode.backgroundColor=[UIColor whiteColor];
    requirecode.layer.borderColor=[UIColor blackColor].CGColor;
    requirecode.layer.borderWidth=1;
    requirecode.layer.cornerRadius=5;
    requirecode.layer.masksToBounds=YES;
    requirecode.placeholder=@"请输入新密码";
    requirecode.secureTextEntry=YES;
    [self.view addSubview:requirecode];
    
    //确认修改密码按键
    UIButton *comfirmation=[UIButton buttonWithType:UIButtonTypeSystem];
    [comfirmation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmation setTitle:@"确认修改" forState:UIControlStateNormal];
    comfirmation.backgroundColor=[UIColor orangeColor];
    comfirmation.layer.cornerRadius=8;
    comfirmation.layer.masksToBounds=YES;
    [comfirmation addTarget:self action:@selector(comfirmationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:comfirmation];
    
    phonenumber.sd_layout
    .topSpaceToView(self.view,100)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    newcode.sd_layout
    .topSpaceToView(phonenumber,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    requirecode.sd_layout
    .topSpaceToView(newcode,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
    
    comfirmation.sd_layout
    .topSpaceToView(requirecode,15)
    .rightSpaceToView(self.view,10)
    .leftSpaceToView(self.view,10)
    .heightIs(textheight);
}

#pragma mark - 确认修改密码
-(void)comfirmationClick
{
    
    NSString *string=[[NSUserDefaults standardUserDefaults]stringForKey:@"TheLoginpassedcode"];
    
    if([newcode.text isEqualToString:string]){
      NSString *sesid=QU_DATA(@"SESID");
        
       [loginRequest ChangeCodeRequest:sesid andOldCode:newcode.text andNewCode:requirecode.text andBlock:^(NSString *string) {
           //密码修改成功
           if([string isEqualToString:@"0"]){
             HUD_NAME(@"恭喜，密码修改成功！", 0.95)
               
               [self performSelector:@selector(returntoRootViewController) withObject:nil afterDelay:1.0f];
           }
           
           
       } ];
        
    }else{
        HUD_NAME(@"旧密码错误，请确认！", 0.8);
    }
    
    
}



-(void)returntoRootViewController
{
    RootViewController *rootVC=[[RootViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:rootVC];
    
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
