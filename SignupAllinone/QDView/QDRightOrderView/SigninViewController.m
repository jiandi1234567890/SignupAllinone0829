//
//  SigninViewController.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "SigninViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "TFHpple.h"
#import "FMDB.h"
#import "BARModel.h"
#import "UserModel.h"
#import "FMDBManager.h"

#define CC_MD5_DIGEST_LENGTH    16

@interface SigninViewController ()<UIWebViewDelegate>
{
    NSMutableArray *listArray;
}
@property(nonatomic,strong) NSMutableArray * userinfo;
@property(nonatomic,strong) NSString * urlString;
@property(nonatomic,strong) NSString * tbs;
@property(nonatomic,strong) NSString * BDuss;
@property(nonatomic,strong) NSString * BDname;
@property(nonatomic,strong) NSString * BDnameimage;
@property(nonatomic,strong) NSArray * cookies;

@property(nonatomic,strong) MBProgressHUD * hud;

@end

@implementation SigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"增加账号";
     self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.BDuss=[[NSString alloc]init];
    self.tbs=[[NSString alloc]init];
    self.BDname=[[NSString alloc]init];
    self.BDnameimage=[[NSString alloc]init];
    self.userinfo=[NSMutableArray new];
    //        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userinfo];
    //        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"netstatus"]){
        self.urlString=@"http://wappass.baidu.com/passport/";
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20)];
        //self.webView.tag=1;
        self.webView.backgroundColor=[UIColor whiteColor];
        self.webView.delegate=self;
        self.webView.userInteractionEnabled=YES;//让webView支持交互
        self.webView.scalesPageToFit=YES;//自动缩放以适应屏幕
        self.webView.scrollView.showsVerticalScrollIndicator=NO;//是否显示滚动条
        self.webView.scrollView.bounces=NO;//让webView无法滑动出界限
        NSURL * url = [NSURL URLWithString:self.urlString];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];//远程读取网页
        [self.view addSubview:self.webView];
    }else{
        HUD_NAME(@"没有网络，请检查网络情况！", 3)
    }
    //hud初始化
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.label.text = @"努力加载中...";
    self.hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
    self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:.2f];
    
    [self performSelector:@selector(shutdownhud) withObject:nil afterDelay:5.0];
}
//当网页视图结束加载一个请求之后得到通知
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.hud hideAnimated:YES];
}

-(void)shutdownhud{
    [self.hud hideAnimated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    if([urlString rangeOfString:@"&ssid="].location!=NSNotFound){
        if([urlString rangeOfString:@"&ssid=&"].location==NSNotFound){
            NSLog(@"登录成功");
            
            
            //获取Cookies
            self.cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:@"http://wappass.baidu.com/passport/"]];
            //写入cookie
            NSHTTPCookie *cookie;
            for (cookie in self.cookies) {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            }
            //从Cookies获取Bduss
            for (int i=0; i<self.cookies.count; i++) {
                NSString * bdussStr = [NSString stringWithFormat:@"%@",[self.cookies objectAtIndex:i]];
                if ([bdussStr rangeOfString:@"BDUSS"].location !=NSNotFound) {
                    NSArray  * array= [bdussStr componentsSeparatedByString:@"\""""];
                    self.BDuss=[array objectAtIndex:3];
                    break;
                }
            }
            [self getuserinformation];
            [self gettbs];
            //存储用户信息
            while (1) {
                // 等待条件满足再向下执行但不主卡线程NSRunLoop的方法
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                if(self.BDuss.length>0&&self.BDnameimage.length>0&&self.BDname.length>0&&self.tbs.length>0&&self.cookies.count>0){
                    
                    NSData *datalast=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
                    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:datalast];
                    
                    UserModel *model=[[UserModel alloc]init];
                    model.bdname=self.BDname;
                    model.bdnameimage=self.BDnameimage;
                    model.tbs=self.tbs;
                    model.bduss=self.BDuss;
                    model.cookies=[self.cookies copy];
                    //账户是否重复
                    BOOL twoname = false;
                    //判断是否已存有账户
                    if(array.count>0){
                        //检测是否账户重复
                        for(UserModel *model1 in array){
                            if([model1.bdname isEqualToString:model.bdname]){
                                [self showMessage:@"用户重复"];
                                twoname=YES;
                                break;
                            }else{
                                twoname=NO;
                            }
                        }
                        
                        if(!twoname){
                            self.userinfo=[NSMutableArray arrayWithArray:array];
                            [self.userinfo addObject:model];
                            NSArray *sureArray=[NSArray arrayWithArray:self.userinfo];
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
                            [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
                            
                        }
                        
                    }else{
                         [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allmember"];
                        [self.userinfo addObject:model];
                        NSArray *sureArray=[NSArray arrayWithArray:self.userinfo];
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
                        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];

                    break;
                }
                
            }
            return NO;
            
            
        }else{
            NSLog(@"请正确登录");
            
        }
        
        
    }
    
    return YES;
   
}




//获取tbs和bduss
-(void)gettbs{
    
    
    AFHTTPSessionManager * manager1 = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manager1.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager1.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager1 POST:@"http://tieba.baidu.com/dc/common/tbs" parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        
        NSString * urlHtmlStr = [[NSString alloc]initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        NSData *jsonData = [urlHtmlStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        self.tbs=[dic objectForKey:@"tbs"];
       } failure:^(NSURLSessionDataTask *  task, NSError * error) {
        NSLog(@"tbs 获取失败%@",error);
    }];
    
}


//获取用户头像
-(void)getuserinformation
{
    //获取头像和名称
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    [manager setSecurityPolicy:securityPolicy];
    //2.设置返回数据类型 让其能接收Html数据
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"https://m.baidu.com/usrprofile?action=home&model=user&ori=index"  parameters:nil  progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //解析
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:responseObject];
        NSArray * tdArray = [doc searchWithXPathQuery:@"//div[@id='wrapper']//div[@id='page-bd']//section[@class='user-profile']"];
        TFHppleElement * atitleEle01=[tdArray objectAtIndex:0];
        //获取头像图片地址
        TFHppleElement *nameimageArray=[[[atitleEle01.children objectAtIndex:0] children]objectAtIndex:0];
        self.BDnameimage=[nameimageArray.attributes objectForKey:@"data-timg"];
        // [[NSUserDefaults standardUserDefaults]setObject:self.BDnameimage forKey:@"nameimage"];
        // NSLog(@"nameimageArray:%@",nameimage);
        //获取用户名
        TFHppleElement *namearray=[atitleEle01.children objectAtIndex:1];
        self.BDname=[NSString stringWithFormat:@"%@",namearray.content];
        NSLog(@"self.BDname%@",self.BDname);
        [[NSUserDefaults standardUserDefaults]setObject:self.BDname forKey:@"name"];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        NSLog(@"获取头像失败：%@",error);
    }];
}

//按键提醒显示
-(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.alpha = 0.8f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize=[message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} context:nil].size;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    
    showview.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height)/2,[UIScreen mainScreen].bounds.size.width-40, LabelSize.height+10);
    label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40-LabelSize.width)/2, 5, LabelSize.width, LabelSize.height);
    
    [showview addSubview:label];
    [UIView animateWithDuration:2.5 animations:^{showview.alpha=0.0f;}    completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
