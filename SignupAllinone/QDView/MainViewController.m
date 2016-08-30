//
//  MainViewController.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/13.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "MainViewController.h"
#import "UIView+SDAutoLayout.h"
#import "MainTableViewCell.h"
#import "UserModel.h"
#import "BARModel.h"
#import "FMDBManager.h"
#import "MBProgressHUD.h"
#import "BDlist.h"
#import "BDsign.h"
#import "ChangenameViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "Rootviewcontroller.h"
#import "ZSuduView.h"


#define bgbtnheight  74

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //百度账号数组
    NSMutableArray *_userinfo;
    //账号下贴吧数组
    NSMutableArray *_nameArray;
    //签到需要的字段
    NSString *_bduss;
    NSString *_tbs;
    //时间到标志
    BOOL timeup;
    NSTimer *_timer;

    AppDelegate * _appDelegate;
}
@property(nonatomic,strong) UITableView * tableview;
@property(nonatomic,strong) MBProgressHUD * hud;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.21 green:0.78 blue:0.97 alpha:1.00];
    //解决后台到前台后屏幕控件点击无反应的bug
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"listallget"]||[[NSUserDefaults standardUserDefaults]boolForKey:@"allsign"])
    {
        [self.hud hideAnimated:YES];
    }
    _userinfo=[[NSMutableArray alloc]init];
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    for(UserModel *model in array){
        int i=1;
        FMDBManager *manager = [FMDBManager shareInstance];
        //将product中所有记录都读出来--
        FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@",model.bdname]];
       
        if(![rs next]){
            CUN_DATA(model.bdname, @"name");
            [self refreshviewClick];
            break;
        }else{
        while ([rs next])
        {
            i++;
        }
       
        //获取本地日期,第二天签到状态可以改变了
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd"];
        NSString * time=[dateformatter stringFromDate:senddate];
        if([[NSUserDefaults standardUserDefaults]stringForKey:@"signday"]){
            if(![time isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"signday"]]){
                model.sign=NO;
            }
        }else{
            model.sign=NO;
        }
         model.barnumber=[NSString stringWithFormat:@"%d",i];
        [_userinfo addObject:model];
           
        }
    }
    
    if(_userinfo.count==array.count){
    NSArray *sureArray=[NSArray arrayWithArray:_userinfo];
    NSData *datanew = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
    [[NSUserDefaults standardUserDefaults]setObject:datanew forKey:@"userinfo"];
    }
    [_tableview reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.21 green:0.78 blue:0.97 alpha:1.00];
    self.view.backgroundColor=[UIColor whiteColor];
    _nameArray=[[NSMutableArray alloc]init];
    
    //更改返回键样式
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    //设置导航栏字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    _appDelegate = [[UIApplication sharedApplication]delegate];
    
    //导航栏按键
    UIButton *setBTN=[UIButton buttonWithType:UIButtonTypeSystem];
    setBTN.frame=CGRectMake(0, 0, 60, 35);
    setBTN.layer.cornerRadius=5;
    setBTN.titleLabel.font=[UIFont systemFontOfSize:17];
    setBTN.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
    setBTN.layer.masksToBounds=YES;
    [setBTN setTitle:@"设置" forState:UIControlStateNormal];
    [setBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBTN addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBTN=[[UIBarButtonItem alloc]initWithCustomView:setBTN];
    
    UIButton *saveBTN=[UIButton buttonWithType:UIButtonTypeSystem];
    saveBTN.frame=CGRectMake(0, 0, 170, 35);
    [saveBTN setTitle:@"保存账号至云服务器" forState:UIControlStateNormal];
    [saveBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBTN.titleLabel.font=[UIFont systemFontOfSize:17];
    [saveBTN addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBTN=[[UIBarButtonItem alloc]initWithCustomView:saveBTN];
    
    self.navigationItem.leftBarButtonItem=leftBTN;
    self.navigationItem.rightBarButtonItem=rightBTN;
    
    
    //主页tableview
    self.tableview=[[UITableView alloc]init];
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
    }

    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    //隐藏多余的分割线
    self.tableview.tableFooterView=[[UIView alloc]init];
    //禁止下拉
    self.tableview.bounces=NO;
    [self.view addSubview:self.tableview];
    
    
    UIImageView *bgBTNview=[[UIImageView alloc]init];
    bgBTNview.image=[UIImage imageNamed:@"bg_bottom_menu"];
    bgBTNview.userInteractionEnabled=YES;
    [self.view addSubview:bgBTNview];
    
    UIButton *add=[UIButton buttonWithType:UIButtonTypeCustom];
    add.titleLabel.font=[UIFont systemFontOfSize:16];
    [add setTitle:@"添加账号" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [add setImage:[UIImage imageNamed:@"img_add"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgBTNview addSubview:add];
    
    
    UIButton *allsign=[UIButton buttonWithType:UIButtonTypeCustom];
    [allsign setImage:[UIImage imageNamed:@"img_signin"] forState:UIControlStateNormal];
    [allsign addTarget:self action:@selector(allsignupClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bgBTNview addSubview:allsign];
    
    
    UIButton *refresh=[UIButton buttonWithType:UIButtonTypeCustom];
    refresh.titleLabel.font=[UIFont systemFontOfSize:16];
    [refresh setTitle:@"刷新数据" forState:UIControlStateNormal];
    [refresh setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [refresh setImage:[UIImage imageNamed:@"img_refresh"] forState:UIControlStateNormal];
    [refresh addTarget:self action:@selector(refreshbuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [bgBTNview addSubview:refresh];
    
    
    
    self.view.sd_equalWidthSubviews=@[add,allsign,refresh];
    
    
    //控件约束
    bgBTNview.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0)
    .heightIs(bgbtnheight);
    
    
    add.sd_layout
    .topSpaceToView(bgBTNview,10)
    .bottomSpaceToView(bgBTNview,0)
    .leftSpaceToView(bgBTNview,0);
    
    
    allsign.sd_layout
    .topSpaceToView(bgBTNview,0)
    .bottomSpaceToView(bgBTNview,0)
    .leftSpaceToView(add,0);
    
    refresh.sd_layout
    .topSpaceToView(bgBTNview,10)
    .bottomSpaceToView(bgBTNview,0)
    .leftSpaceToView(allsign,0);
    
    self.tableview.sd_layout
    .topSpaceToView(self.view,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(bgBTNview,0);
    
    
    
    float sizewidth=self.view.bounds.size.width/3;
    float sizeheight=bgbtnheight-10;
    
    
    CGSize addimg=add.imageView.intrinsicContentSize;
    CGSize addtitle=add.titleLabel.intrinsicContentSize;
    add.imageEdgeInsets=UIEdgeInsetsMake(sizeheight-(addtitle.width/2+addtitle.height), (sizewidth-addtitle.width/2+5)/2, addtitle.height+5, (sizewidth-addtitle.width/2+5)/2);
    add.titleEdgeInsets=UIEdgeInsetsMake(sizeheight-addtitle.height, -addimg.width, 0, 0);
    
    allsign.imageEdgeInsets=UIEdgeInsetsMake(0, (sizewidth-bgbtnheight)/2, 0, (sizewidth-bgbtnheight)/2);
    
    CGSize refreshimg=refresh.imageView.intrinsicContentSize;
    CGSize refreshtitle=refresh.titleLabel.intrinsicContentSize;
    refresh.imageEdgeInsets=UIEdgeInsetsMake(sizeheight-(refreshtitle.width/2+refreshtitle.height), (sizewidth-refreshtitle.width/2+5)/2, refreshtitle.height+5, (sizewidth-refreshtitle.width/2+5)/2);
    refresh.titleEdgeInsets=UIEdgeInsetsMake(sizeheight-refreshtitle.height, -refreshimg.width, 0, 0);
    
//    self.timer=[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timeforsign) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
//    [self.timer fire];
}

#pragma mark --定时签到
-(void)timeforsign{
    NSLog(@"timefor");
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString * time=[dateformatter stringFromDate:senddate];

  NSArray *timeArray=[[NSUserDefaults standardUserDefaults]arrayForKey:@"timeArray"];
    if(timeArray!=nil){
         NSString *timeString=[NSString stringWithFormat:@"%@:%@",timeArray[0],timeArray[1]];
        NSLog(@"time:%@",time);
        NSLog(@"timestring:%@",timeString);

        if([time isEqualToString:timeString]){
            
            [self AllMenmberssignin];
        }
        
        
    }
    
}

//刷新列表
-(void)refreshviewClick{
    NSString *string=[[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"netstatus"]){
        if(string){
            //开始刷新时把侧滑手势关闭
            [_appDelegate.LeftSlideVC setPanEnabled:NO];
            [BDlist getlist];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            self.hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
            self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
            self.hud.label.text=[NSString stringWithFormat:@"(%@)贴吧列表刷新中...",string];
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
                            
                            [self.hud hideAnimated:YES];
                            [self viewWillAppear:YES];
                        //刷新完把侧栏开启
                            [_appDelegate.LeftSlideVC setPanEnabled:YES ];
                            //[_tableview reloadData];
                            
                        });
                        break;
                    }
                    
                }
            });
            
        }
    }else{
        HUD_NAME(@"没有网络，请检查！", 3)
    }
}


#pragma mark --tableviewdatasource
//区头
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    UILabel *barID=[[UILabel alloc]init];
    barID.text=@"贴吧ID";
    barID.textColor=[UIColor grayColor];
    barID.textAlignment=NSTextAlignmentCenter;
    
    UILabel *signcount=[[UILabel alloc]init];
    signcount.text=@"签到数";
    signcount.textAlignment=NSTextAlignmentCenter;
    signcount.textColor=[UIColor grayColor];
    
    
    UILabel *time=[[UILabel alloc]init];
    time.text=@"时间";
    time.textAlignment=NSTextAlignmentCenter;
    time.textColor=[UIColor grayColor];
    
    
    UILabel *state=[[UILabel alloc]init];
    state.text=@"状态";
    state.textAlignment=NSTextAlignmentCenter;
    state.textColor=[UIColor grayColor];
    
    
    [view addSubview:barID];
    [view addSubview:signcount];
    [view addSubview:time];
    [view addSubview:state];
    
    
    barID.sd_layout.topSpaceToView(view,0).bottomSpaceToView(view,0).widthIs(self.view.bounds.size.width*0.38);
    signcount.sd_layout.topSpaceToView(view,0).bottomSpaceToView(view,0).widthIs(self.view.bounds.size.width*0.27).leftSpaceToView(barID,0);
    time.sd_layout.topSpaceToView(view,0).bottomSpaceToView(view,0).widthIs(self.view.bounds.size.width*0.19).leftSpaceToView(signcount,0);
    state.sd_layout.topSpaceToView(view,0).bottomSpaceToView(view,0).widthIs(self.view.bounds.size.width*0.16).leftSpaceToView(time,0);
    
    return view;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _userinfo.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        
        cell=[[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    //选中状态
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
     UserModel *model=_userinfo[indexPath.row];
    
   
    //最多显示7个字符
    NSString *string=model.bdname;
    // NSString *string=@"nihao";
    if(string.length>7){
        string=[string substringWithRange:NSMakeRange(0, 7)];
    }
    cell.barID.text=string;
    if(model.noneedsign){
        cell.state.textColor=[UIColor redColor];
        cell.state.text=@"不签到";
        cell.time.text=@"-";
        cell.signcount.text=[NSString stringWithFormat:@"0/%@",model.barnumber];
    }else{
        if(!model.sign){
            cell.state.textColor=[UIColor blackColor];
            cell.state.text=@"-";
            cell.time.text=@"-";
            cell.signcount.text=[NSString stringWithFormat:@"0/%@",model.barnumber];
        }else{
            cell.signcount.text=[NSString stringWithFormat:@"%@/%@",model.barnumber,model.barnumber];
            cell.time.text=model.signtime;
            cell.state.textColor=[UIColor redColor];
            cell.state.text=@"OK";
            }
    }
    [cell updateLayoutWithCellContentView:cell];
    
    return cell;
    
}

#pragma mark --tableviewdelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     UserModel *model=_userinfo[indexPath.row];
    NSString *string=model.bdname;
    CUN_DATA(string, @"name");
    ViewController *vVC=[[ViewController alloc]init];
    [self.navigationController pushViewController:vVC animated:YES];
    
    
}

#pragma mark --导航栏设置、保存按键
//侧栏
- (void)openOrCloseLeftList
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}

-(void)saveButtonClick{
    
    UIViewController *vc=nil;
    if (QU_DATA(@"TheLoginname")!=nil) {
        vc=[[ChangenameViewController alloc]init];
        
    }else{
        vc=[[RootViewController alloc]init];
    }

    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"保存到新手机签到");
}

#pragma mark --增加、签到、刷新数据

-(void)addbuttonClick{
   
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionPush;//可更改为其他方式
    transition.subtype = kCATransitionFromTop;//可更改为其他方式
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    SigninViewController *signVC=[[SigninViewController alloc]init];
    [self.navigationController pushViewController:signVC animated:YES];
}

-(void)allsignupClick{
    
    [self AllMenmberssignin];
    
}
-(void)refreshbuttonClick{
    
    [self refreshlist];
    
}


#pragma mark --刷新数据

-(void)refreshlist{
    if(_userinfo.count>0){
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"netstatus"]){
            //开始刷新时把侧滑手势关闭
            [_appDelegate.LeftSlideVC setPanEnabled:NO];
            for(int i=0;i<_userinfo.count;i++){
                //dispatch_async(group, ^{
                //获取当前用户信息
                UserModel *model=_userinfo[i];
                [[NSUserDefaults standardUserDefaults]setObject:model.bdname forKey:@"name"];
                NSLog(@"name:%@",model.bdname);
                [BDlist getlist];
                self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                self.hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                self.hud.label.text=[NSString stringWithFormat:@"(%@)贴吧列表刷新中...",model.bdname];
                while (1) {
                    //不让此循环卡住主线程
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    if([[NSUserDefaults standardUserDefaults]boolForKey:@"listallget"]){
                        [self.hud hideAnimated:YES];
                        [self viewWillAppear:YES];
                        break;
                    }
                    
                }
                
            }
            //刷新完后开启侧滑手势
            [_appDelegate.LeftSlideVC setPanEnabled:YES];
        }else{
            HUD_NAME(@"没有网络，请检查！", 3)
        }
        
    }else{
        SigninViewController *signVC=[[SigninViewController alloc]init];
        [self.navigationController pushViewController:signVC animated:YES];
    }
    
}


#pragma mark - 一键签到
-(void)allsignin{
    timeup=NO;
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
        if(![[NSUserDefaults standardUserDefaults]boolForKey:@"allsign"])
        {
            //判断当前是否有账号
            if([[NSUserDefaults standardUserDefaults]stringForKey:@"name"]){
//                __block  MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                self.hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
                self.hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];

                self.hud.label.text=[NSString stringWithFormat:@"(%@)签到中...",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]];
//                hud1.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
//                hud1.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
                //每个贴吧签到
                if(_nameArray.count>0){
                    __block int number=0;
                    //开辟一个子线程作用作for循环
                    dispatch_queue_t group = dispatch_queue_create(nil, nil);
                    for (int i=0; i<_nameArray.count; i++) {
                        //启动定时器
                        [_timer fire];
                        dispatch_async(group, ^{
                            //吧名
                            //由于后面有用到while（1）等待，为了防止其与afnetworking和hud显示冲突，回主线程做post和界面刷新
                            dispatch_queue_t mainQueue = dispatch_get_main_queue();
                            dispatch_async(mainQueue, ^{
                                [BDsign signSinglewithBarname:_nameArray[i] andBDUSS:_bduss andTBS:_tbs andBlock:^(NSString *state) {
                                    if([state isEqualToString:@"success"]){
                                        
                                        number++;
                                        NSLog(@"签到%d",number);
                                        self.hud.detailsLabel.text=[NSString stringWithFormat:@"已签到：%d/%lu",number,(unsigned long)_nameArray.count];
                                        //单账户签到完成
                                        if(number==_nameArray.count){
                                                [self.hud hideAnimated:YES afterDelay:0.3];
                                            number=0;
                                            //获取本地日期
                                            NSDate *  senddate=[NSDate date];
                                            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                                            [dateformatter setDateFormat:@"dd"];
                                            NSString * time=[dateformatter stringFromDate:senddate];
                                            [[NSUserDefaults standardUserDefaults]setObject:time forKey:@"signday"];
                                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"allsign"];
                                            //签到完成关闭定时器
                                            [_timer invalidate];
                                            _timer=nil;
                                        }
                                        
                                    }else{
                                        number++;
                                        //签到完成
                                        if(number==_nameArray.count){
                                            
                                                [self.hud hideAnimated:YES afterDelay:0.3];
                                             
                                            number=0;
                                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"allsign"];
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
                    [self.hud hideAnimated:YES];
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


-(void)changeTimeup{
    timeup=YES;
}


#pragma mark - 多账户签到

-(void)AllMenmberssignin{
   
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
//    _userinfo=[NSMutableArray arrayWithArray:array];
    //设置一个子线程跑for循环
    dispatch_queue_t group = dispatch_queue_create(nil, nil);
    if(array.count>0){
        //if(![[NSUserDefaults standardUserDefaults]boolForKey:@"allmember"]){
        
        for(int i=0;i<array.count;i++){
            dispatch_async(group, ^{
                //开始签到时把侧滑手势关闭
                [_appDelegate.LeftSlideVC setPanEnabled:NO];
                //获取签到时间
                NSDate *  senddate=[NSDate date];
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                [dateformatter setDateFormat:@"HH:mm"];
                NSString * time=[dateformatter stringFromDate:senddate];
                
                [_nameArray removeAllObjects];
                
                //获取当前用户信息
                UserModel *model=_userinfo[i];
                _tbs=model.tbs;
                _bduss=model.bduss;
                [[NSUserDefaults standardUserDefaults]setObject:model.bdname forKey:@"name"];
                //设置为不签到的账号不签到
                if(!model.noneedsign){
                //清理所有cookies  和设置Cookies
                NSURL *url = [NSURL URLWithString:@"http://wappass.baidu.com/passport/"];
                if (url) {
                    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                    for (int i = 0; i < [cookies count]; i++) {
                        NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                    }
                }
                
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
                    NSString *string=[NSString new];
                     string=[rs  stringForColumn:@"barname"];
                    [_nameArray addObject:string];
                }
                //已签到过的贴吧无需再签
               if(!model.sign){
                //回到主线程 处理界面信息并签到
                dispatch_queue_t mainQueue = dispatch_get_main_queue();
                dispatch_async(mainQueue, ^{
                    if(_nameArray.count>0){
                        [self allsignin];
                    }
                    
                });
                }else{
                    time=model.signtime;
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"allsign"];
                    //回到主线程 处理界面信息
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_async(mainQueue, ^{
                        NSString *string=[NSString stringWithFormat:@"%@账号贴吧今日已签，请明日再签！",model.bdname];
                        HUD_NAME(string, 0.5);
                        //判断之后开启手势
                        [_appDelegate.LeftSlideVC setPanEnabled:YES];
                    });
                   
                }
                
                while (1) {
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                    if([[NSUserDefaults standardUserDefaults]boolForKey:@"allsign"])
                    {
                        // 回到主线程 处理界面信息
                        dispatch_queue_t mainQueue1 = dispatch_get_main_queue();
                        dispatch_async(mainQueue1, ^{
                            model.signtime=time;
                            model.sign=YES;
                            [_userinfo replaceObjectAtIndex:i withObject:model];
                            [self.tableview reloadData];
                           
                            //签到完成保存
                            NSArray *sureArray=[NSArray arrayWithArray:_userinfo];
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
                            [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
                            //签到完成时把侧滑手势开启
                            [_appDelegate.LeftSlideVC setPanEnabled:YES];

                            });
                        break;
                    }
                }
                
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
                //签到完一个账号，暂时停顿一小会儿
                [NSThread sleepForTimeInterval:0.6f];
                    
            }
             
                //签到完成时把侧滑手势开启
                [_appDelegate.LeftSlideVC setPanEnabled:YES];
            });
            
        }
            // [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"allmember"];
        //获取本地日期
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"dd"];
            NSString * time=[dateformatter stringFromDate:senddate];
            [[NSUserDefaults standardUserDefaults]setObject:time forKey:@"signday"];

//        }else{
//        HUD_NAME(@"今日已全部签到！", 0.8)
//        
//        }
    
    }else{
        HUD_NAME(@"请先登录百度账号", 0.8)
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
