//
//  ViewController.m
//  signup-allinone
//
//  Created by 张海禄 on 16/5/12.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "SigninViewController.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "UserModel.h"
#import "BARModel.h"
#import "FMDBManager.h"
#import "MyTableViewCell.h"
#import "ChangenameViewController.h"
#import "SlidebarView.h"
#import "QDNavView.h"
#import "ZChoiceBack.h"
#import "ZSuduView.h"
#import "ChangecodeViewController.h"
#import "BDlist.h"
#import "BDsign.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    //百度账号数组
    NSMutableArray *userinfo;
    NSString *BDuss;
    NSString *tbs;
    NSString *BDnameimage;
    NSString *BDname;
    BOOL slidebarHiden;
    //是否超级签到
    BOOL allsign;
    //时间到标志
    BOOL timeup;
    NSTimer *_timer;
}
//贴吧名称数组
@property(nonatomic,strong) NSMutableArray * nameArray;
//界面提示
@property(nonatomic,strong) MBProgressHUD * hud;
//侧栏
@property(nonatomic,strong) SlidebarView * sView;

@end


@implementation ViewController
//-(void)viewDidAppear:(BOOL)animated
-(void)viewWillAppear:(BOOL)animated{
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"netstatus"]){
        if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
            NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
            NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
            if(array.count>0){
                userinfo=[NSMutableArray arrayWithArray:array];
                for(UserModel *model in userinfo){
                    if([model.bdname isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]){
                        BDuss=model.bduss;
                        tbs=model.tbs;
                        BDnameimage=model.bdnameimage;
                        BDname=model.bdname;
                    }
                }
            }
            //打开数据库
            FMDBManager *manager = [FMDBManager shareInstance];
            
            //获取本地日期,第二天签到状态可以改变了
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"dd"];
            NSString * time=[dateformatter stringFromDate:senddate];
            if([[NSUserDefaults standardUserDefaults]stringForKey:@"signday"]){
                if(![time isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"signday"]]){
                    if (![manager.dataBase executeUpdate:[NSString stringWithFormat:@"update member%@  set sign=? ",BDname],@"未签到"]){
                    }else{
                        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
                    }
                }
            }
            
        }
        [self reloadtableview];
    }else{
        HUD_NAME(@"没有网络，请检查！", 2.5)
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
        FMDBManager *manager = [FMDBManager shareInstance];
        //将product中对应的成员字表所有记录都读出来
        FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]];
        //查询该表是否创建了
        if(![rs next]){
            [self reflashbuttonClick];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    allsign=NO;
    timeup=NO;
    self.navigationItem.title=@"贴吧列表";
    //设置导航栏颜色
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
    
    //更改返回键样式
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    
    userinfo=[NSMutableArray new];
    self.nameArray=[NSMutableArray new];
    BDname=[NSString new];
    BDnameimage=[NSString new];
    BDuss=[NSString new];
    tbs=[NSString new];
    
    //读取当前账号的信息
    if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
        NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if(array.count>0){
            
            userinfo=[NSMutableArray arrayWithArray:array];
            
            for(UserModel *model in userinfo){
                if([model.bdname isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]){
                    BDuss=model.bduss;
                    tbs=model.tbs;
                    BDnameimage=model.bdnameimage;
                    BDname=model.bdname;
                }
            }
        }
        //打开数据库
        FMDBManager *manager = [FMDBManager shareInstance];
        //将product中所有记录都读出来--
        FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]];
        while ([rs next])
        {
            BARModel *barmodel=[BARModel new];
            barmodel.barname=[rs  stringForColumn:@"barname"];
            barmodel.signup=[rs stringForColumn:@"sign"];
            barmodel.rangename=[rs stringForColumn:@"rangename"];
            barmodel.level=[rs stringForColumn:@"level"];
            [self.nameArray addObject:barmodel];
            
        }
        
    }else{
        BDname=@"请登录账号";
    }
    
    tableview=[[UITableView alloc]initWithFrame:self.view.frame];
    
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    tableview.delegate=self;
    tableview.dataSource=self;
    //隐藏多余的分割线
    tableview.tableFooterView=[[UIView alloc]init];
    //禁止下拉
    tableview.bounces=NO;
    [self.view addSubview:tableview];
    
}

#pragma mark - 主页刷新按键
//刷新按键
-(void)reflashbuttonClick{
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"netstatus"]){
        if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
            [BDlist getlist];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            self.hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
            self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
            self.hud.label.text = @"贴吧列表刷新中...";
            //设置一个子线程跑循环
            dispatch_queue_t group = dispatch_queue_create(nil, nil);
            dispatch_async(group, ^{
                while (1) {
                    //不让此循环卡住主线程
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    if([[NSUserDefaults standardUserDefaults]boolForKey:@"listallget"]){
                        // 回到主线程 处理界面信息
                        dispatch_queue_t mainQueue = dispatch_get_main_queue();
                        dispatch_async(mainQueue, ^{
                            [self reloadtableview];
                        });
                        break;
                    }
                    
                }
            });
            
        }else{
            //[self hudwithstring:@"请先登录百度账号" withtime:1];
            SigninViewController *signinVC=[[SigninViewController alloc]init];
            self.navigationController.navigationBarHidden = NO;//隐藏导航条
            [self.navigationController pushViewController:signinVC animated:YES];
        }
    }else{
        HUD_NAME(@"没有网络，请检查！", 3)
    }
}

//刷新列表
-(void)reloadtableview{
    
    [self.nameArray removeAllObjects];
    
    FMDBManager *manager = [FMDBManager shareInstance];
    //将product中对应的成员字表所有记录都读出来
    FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]];
    while ([rs next])
    {
        BARModel *barmodel=[BARModel new];
        barmodel.barname=[rs  stringForColumn:@"barname"];
        barmodel.signup=[rs stringForColumn:@"sign"];
        barmodel.rangename=[rs stringForColumn:@"rangename"];
        barmodel.level=[rs stringForColumn:@"level"];
        [self.nameArray addObject:barmodel];
        
    }
    [tableview reloadData];
    [self.hud hideAnimated:YES];
    
    
}
#pragma mark - 主页签到按键
-(void)alertcontroller{
    
        allsign=NO;
        [self allsignin];
        
   
}

#pragma mark - 一键签到
-(void)allsignin{
    
    BOOL todatysign=NO;
    //获取签到时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString * signtime=[dateformatter stringFromDate:senddate];

    timeup=NO;
    
    for(int i=0;i<userinfo.count;i++){
        UserModel *model=userinfo[i];
        if([model.bdname isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]){
            todatysign=model.sign;
        }
    }

    //设置签到速率，默认为0.08s
    if (QU_DATA(@"QDSHUD")==nil) {
        CUN_DATA(@"50", @"QDSHUD")
    }
    float timeShu = 2/[QU_DATA(@"QDSHUD") floatValue];
    //初始化定时器
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:timeShu target:self selector:@selector(changeTimeup) userInfo:nil repeats:YES];
    //将定时器加入主循环中
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    //判断是否有网络
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"netstatus"]){
        //判断是否全部签到
        if(!todatysign)
        {
            //判断当前是否有账号
            if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
                __block  MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                //hud.label.text =@"(%@)签到中...";
                hud1.label.text=[NSString stringWithFormat:@"(%@)签到中...",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]];
                hud1.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
                hud1.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
                //每个贴吧签到
                if(self.nameArray.count>0){
                    __block int number=0;
                    //开辟一个子线程作用作for循环
                    dispatch_queue_t group = dispatch_queue_create(nil, nil);
                    for (int i=0; i<self.nameArray.count; i++) {
                        //启动定时器
                        [_timer fire];
                        dispatch_async(group, ^{
                            //吧名
                            BARModel *barmodel=self.nameArray[i];
                            
                            
                            //由于后面有用到while（1）等待，为了防止其与afnetworking和hud显示冲突，回主线程做post和界面刷新
                            dispatch_queue_t mainQueue = dispatch_get_main_queue();
                            dispatch_async(mainQueue, ^{
                                [BDsign signSinglewithBarname:barmodel.barname andBDUSS:BDuss andTBS:tbs andBlock:^(NSString *state) {
                                    if([state isEqualToString:@"success"]){
                                        
                                        number++;
                                        hud1.detailsLabel.text=[NSString stringWithFormat:@"已签到：%d/%lu",number,(unsigned long)self.nameArray.count];
                                        //签到完成
                                        if(number==self.nameArray.count){
                                            if(!allsign){
                                                [hud1 hideAnimated:YES afterDelay:0.3];
                                                [self reloadtableview];
                                                [self performSelector:@selector(callarray:) withObject:[NSArray arrayWithObjects:@"所有贴吧已签到完成。",@"1",nil] afterDelay:0.5];
                                                
                                                
                                            }else{
                                                //[self reloadtableview];
                                                [hud1 hideAnimated:YES];
                                            }
                                            number=0;
                                            //获取本地日期
                                            NSDate *  senddate=[NSDate date];
                                            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                                            [dateformatter setDateFormat:@"dd"];
                                            NSString * time=[dateformatter stringFromDate:senddate];
                                            [[NSUserDefaults standardUserDefaults]setObject:time forKey:@"signday"];
                                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"allsign"];
                                            
                                            for(int m=0;m<userinfo.count;m++){
                                                UserModel *model=userinfo[m];
                                                if([model.bdname isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]){
                                                    model.signtime=signtime;
                                                    model.sign=YES;
                                                    [userinfo replaceObjectAtIndex:m withObject:model];
                                                    //签到完成保存
                                                    NSArray *sureArray=[NSArray arrayWithArray:userinfo];
                                                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
                                                    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
                                                }
                                            }
                                            
                                            
                                            //签到完成关闭定时器
                                            [_timer invalidate];
                                            _timer=nil;
                                        }
                                        
                                    }else{
                                        number++;
                                        //签到完成
                                        if(number==self.nameArray.count){
                                            if(!allsign){
                                                [self reloadtableview];
                                                [hud1 hideAnimated:YES afterDelay:0.3];
                                                [self reloadtableview];
                                            }else{
                                                [hud1 hideAnimated:YES];
                                                // [self reloadtableview];
                                            }
                                            number=0;
                                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"allsign"];
                                            for(int m=0;m<userinfo.count;m++){
                                                UserModel *model=userinfo[m];
                                                if([model.bdname isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]){
                                                    model.signtime=signtime;
                                                    model.sign=YES;
                                                    [userinfo replaceObjectAtIndex:m withObject:model];
                                                    //签到完成保存
                                                    NSArray *sureArray=[NSArray arrayWithArray:userinfo];
                                                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
                                                    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
                                                }
                                            }

                                            //签到完成关闭定时器
                                            [_timer invalidate];
                                            _timer=nil;
                                        }
                                        
                                    }
                                }];
                            });
                            while (1) {
                                //不让此循环卡住主线程
                                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                if(timeup){
                                    timeup=NO;
                                    break;
                                }
                            }
                        });
                    }
                }else{
                    [hud1 hideAnimated:YES];
                    HUD_NAME(@"无贴吧列表\n点击刷新按键或确认该账号下是否有关注贴吧！", 2.0f);
                }
            }else{
                
                HUD_NAME(@"请先登录百度账号", 1)
            }
        }else{
            HUD_NAME(@"今日贴吧已全部签到了，无需再签到！", 1)
        }
    }else{
        HUD_NAME(@"没有网络，请检查！", 1)
    }
    
}


//hud
-(void)callarray:(NSArray *)array
{
    HUD_NAME(array[0],[array[1] floatValue])
}
-(void)changeTimeup{
    timeup=YES;
}

#pragma mark - 多账户签到
-(void)AllMenmberssignin{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    userinfo=[NSMutableArray arrayWithArray:array];
    //设置一个子线程跑for循环
    dispatch_queue_t group = dispatch_queue_create(nil, nil);
    if(array.count>0){
        for(int i=0;i<array.count;i++){
            dispatch_async(group, ^{
                [self.nameArray removeAllObjects];
                //清理所有cookies  和设置Cookies
                NSURL *url = [NSURL URLWithString:@"http://wappass.baidu.com/passport/"];
                if (url) {
                    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                    for (int i = 0; i < [cookies count]; i++) {
                        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                    }
                }
                UserModel *model=userinfo[i];
                [[NSUserDefaults standardUserDefaults]setObject:model.bdname forKey:@"name"];
                BDuss=model.bduss;
                tbs=model.tbs;
                BDnameimage=model.bdnameimage;
                BDname=model.bdname;
                //写入cookies
                NSData *cookiesdata =[NSKeyedArchiver archivedDataWithRootObject:model.cookies];
                if([cookiesdata length]) {
                    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
                    NSHTTPCookie *cookie;
                    for (cookie in cookies) {
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                    }
                }
                
                FMDBManager *manager = [FMDBManager shareInstance];
                //将product中所有记录都读出来--
                FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]]];
                while ([rs next])
                {
                    BARModel *barmodel=[BARModel new];
                    barmodel.barname=[rs  stringForColumn:@"barname"];
                    barmodel.signup=[rs stringForColumn:@"sign"];
                    barmodel.rangename=[rs stringForColumn:@"rangename"];
                    barmodel.level=[rs stringForColumn:@"level"];
                    
                    [self.nameArray addObject:barmodel];
                }
                //回到主线程 处理界面信息
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    if(self.nameArray.count>0){
                        [self allsignin];
                    }
                    
                });
                while (1) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    if([[NSUserDefaults standardUserDefaults]boolForKey:@"allsign"])
                    {
                        // 回到主线程 处理界面信息
                        dispatch_queue_t mainQueue1 = dispatch_get_main_queue();
                        dispatch_async(mainQueue1, ^{
                            
                            [self reloadtableview];
                            NSLog(@"1");
                            
                        });
                        break;
                    }
                }
                
                
                
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
                //签到完一个账号，暂时停顿一小会儿
                [NSThread sleepForTimeInterval:0.6f];
                NSLog(@"2");
            });
        }
        //获取本地日期
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd"];
        NSString * time=[dateformatter stringFromDate:senddate];
        [[NSUserDefaults standardUserDefaults]setObject:time forKey:@"signday"];
        
        
    }else{
        HUD_NAME(@"请先登录百度账号", 0.8)
    }
}

#pragma mark -- 导航栏按钮
//菜单按键
-(void)rightbarbuttonClick{
    
    if(slidebarHiden){
        [UIView animateWithDuration:0.3 animations:^{
            self.sView.hidden=NO;
            self.view.frame=CGRectMake(-130,0, self.navigationController.view.frame.size.width+130, self.navigationController.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            slidebarHiden=NO;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
            self.sView.hidden=YES;
            slidebarHiden=YES;
        }];
    }
    
}

#pragma mark - UITabelViewDatasource
//表头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:0.9];
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    imageview.layer.cornerRadius=8;
    imageview.layer.masksToBounds=YES;
    
    UILabel *namelabel=[[UILabel alloc]init];
    namelabel.backgroundColor=[UIColor clearColor];
    namelabel.font=[UIFont boldSystemFontOfSize:19];
    
    UILabel *countlabel=[[UILabel alloc]init];
    countlabel.backgroundColor=[UIColor clearColor];
    countlabel.font=[UIFont systemFontOfSize:14];
    
    if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
        [imageview setImageWithURL:[NSURL URLWithString:BDnameimage] placeholderImage:IMAGE_PASE(@"sg_notImg", @"png")];
        namelabel.text=BDname;
        NSString *string=[NSString stringWithFormat:@"共:%lu个贴吧",(unsigned long)self.nameArray.count];
        NSString *string1=[NSString stringWithFormat:@"%lu",(unsigned long)self.nameArray.count];
        NSMutableAttributedString *attributedstring=[[NSMutableAttributedString alloc]initWithString:string];
        [attributedstring addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, [string1 length])];
        countlabel.attributedText=attributedstring;
        
        
    }else{
        imageview.image=IMAGE_PASE(@"sg_notImg", @"png");
        namelabel.text=@"未添加贴吧";
    }
    
    //刷新按键
    UIButton *reflashBTN=[UIButton buttonWithType:UIButtonTypeSystem];
    [reflashBTN setTitle:@"刷新" forState:UIControlStateNormal];
    reflashBTN.backgroundColor=[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:0.70];
    reflashBTN.titleLabel.font=[UIFont systemFontOfSize:20];
    reflashBTN.layer.cornerRadius=5;
    reflashBTN.layer.masksToBounds=YES;
    [reflashBTN addTarget:self action:@selector(reflashbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //签到按键
    UIButton *allsigninBTN=[UIButton buttonWithType:UIButtonTypeSystem];
    [allsigninBTN setTitle:@"签到" forState:UIControlStateNormal];
    allsigninBTN.backgroundColor=[UIColor colorWithRed:0.82 green:0.82 blue:0.82 alpha:0.80];
    allsigninBTN.titleLabel.font=[UIFont systemFontOfSize:20];
    allsigninBTN.layer.cornerRadius=5;
    allsigninBTN.layer.masksToBounds=YES;
    
    [allsigninBTN addTarget:self  action:@selector(alertcontroller) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:imageview];
    [view addSubview:namelabel];
    [view addSubview:reflashBTN];
    [view addSubview:allsigninBTN];
    [view addSubview:countlabel];
    
    namelabel.sd_layout
    .leftSpaceToView(imageview,15)
    .topSpaceToView(view,5)
    .rightSpaceToView(view,120)
    .heightIs(40);
    
    countlabel.sd_layout
    .leftSpaceToView(namelabel,10)
    .topSpaceToView(view,15)
    .rightSpaceToView(view,5)
    .heightIs(30);
    
    reflashBTN.sd_layout
    .leftSpaceToView(imageview,15)
    .bottomEqualToView(imageview)
    .heightIs(40)
    .widthIs(90);
    
    allsigninBTN.sd_layout
    .leftSpaceToView(reflashBTN,20)
    .bottomEqualToView(imageview)
    .heightIs(40)
    .widthIs(90);
    
    return view;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.nameArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
     cell=[[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    BARModel *barmodel=self.nameArray[indexPath.row];
    if([barmodel.signup isEqualToString:@"未签到"]){
        cell.signup.textColor=[UIColor redColor];
    }else{
        cell.signup.textColor=[UIColor grayColor];
    }
    cell.barname.text=[NSString stringWithFormat:@"%@吧",barmodel.barname];
    cell.rangename.text=[NSString stringWithFormat:@"头衔:%@",barmodel.rangename];
    cell.level.text=barmodel.level;
    cell.signup.text=barmodel.signup;
    return cell;
}
#pragma mark - 签到单个贴吧
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BARModel *barmodel=self.nameArray[indexPath.row];
    
    if([barmodel.signup isEqualToString:@"未签到"]){
        
        [BDsign signSinglewithBarname:barmodel.barname andBDUSS:BDuss andTBS:tbs andBlock:^(NSString *state) {
            if([state isEqualToString:@"success"]){
                [self reloadtableview];
                NSString * hudStr = [NSString stringWithFormat:@"%@吧签到成功",barmodel.barname];
                HUD_NAME(hudStr, 0.5)
                //获取本地日期
                NSDate *  senddate=[NSDate date];
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"dd"];
                NSString * time=[dateformatter stringFromDate:senddate];
                [[NSUserDefaults standardUserDefaults]setObject:time forKey:@"signday"];
                
            }else{
                NSString * hudStr = [NSString stringWithFormat:@"%@吧签到失败",barmodel.barname];
                HUD_NAME(hudStr, 0.8)
            }
        }];
        
    }else{
        HUD_NAME(@"该帖吧已签到过了，无需重复签到", 0.8)
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
