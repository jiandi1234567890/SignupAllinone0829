//
//  ChangenameViewController.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//


#import "ChangenameViewController.h"
#import "UserModel.h"
#import "UIKit+AFNetworking.h"
#import "SigninViewController.h"
#import "FMDBManager.h"
#import "RootViewController.h"
#import "loginRequest.h"


@interface ChangenameViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    NSMutableArray *nameArray;
}

@end

@implementation ChangenameViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
        NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
        NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
        nameArray=[NSMutableArray arrayWithArray:array];
    
   [tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    nameArray=[NSMutableArray new];
    self.navigationItem.title=@"账号管理";
    
    self.view.backgroundColor=[UIColor whiteColor];
    tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    tableview.backgroundColor=[UIColor whiteColor];
    tableview.delegate=self;
    tableview.dataSource=self;
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    nameArray=[NSMutableArray arrayWithArray:array];
    //隐藏多余的分割线
    tableview.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:tableview];
    
    [self addButtonUserName];
   
}


#pragma mark － UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
   
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    UserModel *model=nameArray[indexPath.row];
    
   NSURL *url=[NSURL URLWithString:model.bdnameimage];
    NSString *string=[NSString stringWithFormat:@"%@",model.bdname];
    
        [cell.imageView setImageWithURL:url];
         cell.textLabel.text=string;

    
    if([[[NSUserDefaults standardUserDefaults]stringForKey:@"name"] isEqualToString:model.bdname]){
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.detailTextLabel.text=@"当前账号";
    }else{
        cell.detailTextLabel.text=@"";
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==(nameArray.count-1)){
        [tableview reloadData];
    }
}



#pragma mark --账号删除
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *aler=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [aler addAction:[UIAlertAction actionWithTitle:@"删除该账号"  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UserModel *model=nameArray[indexPath.row];
        CUN_DATA(model.bdname, @"name");
        //打开数据库
        FMDBManager *manager = [FMDBManager shareInstance];
        
        if(![manager.dataBase executeUpdate:[NSString stringWithFormat:@"drop table member%@",QU_DATA(@"name")]]){
            
            NSLog(@"删除%@数据表失败",QU_DATA(@"name"));
        }
        
        [nameArray removeObject:nameArray[indexPath.row]];
        
        if(nameArray.count>0){
            UserModel *model=nameArray[0];
            [[NSUserDefaults standardUserDefaults]setObject:model.bdname forKey:@"name"];
            //清理所有cookies  和设置Cookies
            NSURL *url = [NSURL URLWithString:@"http://wappass.baidu.com/passport/"];
            if (url) {
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                for (int i = 0; i < [cookies count]; i++) {
                    NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                }
            }
            
            NSData *cookiesdata =[NSKeyedArchiver archivedDataWithRootObject:model.cookies];
            if([cookiesdata length]) {
                NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
                NSHTTPCookie *cookie;
                for (cookie in cookies) {
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
                }
            }
            
            
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"name"];
            //清理所有cookies
            NSURL *url = [NSURL URLWithString:@"http://wappass.baidu.com/passport/"];
            if (url) {
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                for (int i = 0; i < [cookies count]; i++) {
                    NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                }
            }
        }
        NSArray *sureArray=[NSArray arrayWithArray:nameArray];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
        [tableview reloadData];
    }]];
    
//    [aler addAction:[UIAlertAction actionWithTitle:@"删除该帐号下的所有贴吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        UserModel *model=nameArray[indexPath.row];
//       [[NSUserDefaults standardUserDefaults]setObject:model.bdname forKey:@"name"];
//        //打开数据库
//        FMDBManager *manager = [FMDBManager shareInstance];
//        
//        if(![manager.dataBase executeUpdate:[NSString stringWithFormat:@"drop table member%@",model.bdname]]){
//            
//            NSLog(@"删除%@数据表失败",model.bdname);
//        }
//    }]];
    
    [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:aler animated:YES completion:nil];
}
#pragma mark - 添加更多帐号
- (void)addButtonUserName
{
    UIView * bomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60, self.view.frame.size.width, 60)];
    bomView.backgroundColor=[UIColor whiteColor];
    bomView.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    bomView.layer.shadowOffset=CGSizeMake(0, 0);
    bomView.layer.shadowOpacity=1;
    bomView.layer.shadowRadius=1;
    [self.view addSubview:bomView];
    NSArray * btnArr = @[@"添加帐号",@"更多功能"];
    float btn_x = 150;
    float btn_y = 40;
    float btn_ox = bomView.frame.size.width/btnArr.count/2-btn_x/2;
    float btn_oy = bomView.frame.size.height/2-btn_y/2;
    for (int i = 0; i < btnArr.count; i++) {
        UIButton * addUserBtn = [[UIButton alloc] initWithFrame:CGRectMake(btn_ox+bomView.frame.size.width/btnArr.count*i,btn_oy, btn_x, btn_y)];
        addUserBtn.tag=i;
        [addUserBtn setTitle:btnArr[i] forState:UIControlStateNormal];
        [addUserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        addUserBtn.clipsToBounds=YES;
        addUserBtn.layer.cornerRadius=5;
        addUserBtn.layer.borderColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00].CGColor;
        addUserBtn.layer.borderWidth=1;
        [addUserBtn addTarget:self action:@selector(addUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bomView addSubview:addUserBtn];
    }
}
- (void)addUserBtnClick:(UIButton *)sender
{
    if (sender.tag ==0) {
        SigninViewController *signinVC=[[SigninViewController alloc]init];
        self.navigationController.navigationBarHidden = NO;//隐藏导航条
        [self.navigationController pushViewController:signinVC animated:YES];
    }else
    {
        UIAlertController *aler=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
#pragma mark --上传百度账号
        [aler addAction:[UIAlertAction actionWithTitle:@"上传百度账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            UIAlertController *secondaler=[UIAlertController alertControllerWithTitle:@"确定上传账号？" message:@"该功能会将服务器账号删除，并上传本地所有账号" preferredStyle:UIAlertControllerStyleAlert];
            
            [secondaler addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                __block  MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.label.text=@"上传中...";
                hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
                hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:0.5f];
                
                //上传本地账号
                NSString *sesid=QU_DATA(@"SESID");
                NSData *dataold=QU_DATA(@"userinfo");
                NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:dataold];
                
                NSMutableArray *uploadArray=[[NSMutableArray alloc]init];
                
                for(int i=0;i<array.count;i++){
                    
                    UserModel *model=array[i];
                    
                    //由于json无法格式化作为array的cookies，把array转成nsstring
                 //   NSString *string = [model.cookies componentsJoinedByString:@","];//分隔符逗号
                    
                    NSDictionary *userinfoDIC=[NSDictionary dictionaryWithObjectsAndKeys:model.bdname,@"username",@"empty",@"cookies",model.bduss,@"bduss",model.bdnameimage,@"portrait",model.tbs,@"tbs",nil];
                    
                    [uploadArray addObject:userinfoDIC];
                    
                }
            //将数组转化成JSON各式数据 返回为Data
                NSData * data = [NSJSONSerialization dataWithJSONObject:uploadArray options:NSJSONWritingPrettyPrinted  error:nil];
                
                //将data数据转化为字符串 并使用NSUTF8
                NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                
                NSString * str = [dataStr stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
                NSLog(@"str:%@",str);
                
                
                //post
                NSDictionary * uploaddataDic = [NSDictionary dictionaryWithObjectsAndKeys:sesid,@"sesid",str,@"list", nil];
                [loginRequest UpLoadUserInformatiaonWithDIC:uploaddataDic andBlock:^(NSString *string) {
                    NSLog(@"%@",string);
                    if([string isEqualToString:@"0"]){
                        [hud hideAnimated:YES];
                        HUD_NAME(@"上传成功！", 0.8);
                    }else{
                        [hud hideAnimated:YES];
                        HUD_NAME(@"上传失败，请重试！", 1.0);
                        
                    }
                    
                }];
                
                
            }]];
            
            [secondaler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            
            
            [self presentViewController:secondaler animated:YES completion:nil];
            
        }]];
    
#pragma mark --同步百度账号
        
        [aler addAction:[UIAlertAction actionWithTitle:@"同步百度账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *secondaler=[UIAlertController alertControllerWithTitle:@"确定同步账号？" message:@"该功能会将服务器账号下载，并与本地账号结合" preferredStyle:UIAlertControllerStyleAlert];
            
            [secondaler addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
             __block   MBProgressHUD * hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.label.text = @"下载中。。。";
                hud.backgroundView.style=MBProgressHUDBackgroundStyleSolidColor;
                hud.backgroundView.color = [UIColor colorWithWhite:0.1f alpha:.2f];
                
                //下载服务器账号
                //post 得到dic后
                NSString *sesid=QU_DATA(@"SESID");
                
                
                NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:sesid,@"sesid", nil];
                
                
                [loginRequest DownLoadUserInformatiaonWithSesid:dic andBlock:^(id responseObject) {
                    
                    //判断是否请求成功，不成功则不执行以下代码，防止崩溃
                    if(responseObject!=nil){
                    
                      //  NSString *message=[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"message"]];
                        NSString * error_code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error_code"]];
                        NSString * code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
                        if([error_code isEqualToString:@"0"]){
                            NSLog(@"下载成功");
                            NSArray *array=[responseObject objectForKey:@"data"];
                            //读取本地账号，进行对比，重复则不添加
//                            NSData *dataold=QU_DATA(@"userinfo");
//                            NSArray *userarray=[NSKeyedUnarchiver unarchiveObjectWithData:dataold];
                            NSMutableArray *localname=[[NSMutableArray alloc]init];
                            NSArray *userarray=[NSArray arrayWithArray:nameArray];
                            for(UserModel *model in userarray){
                                [localname addObject:model.bdname];
                            }
                            NSMutableArray *newuserArray=[NSMutableArray arrayWithArray:userarray];
                            if(userarray.count>0){
                                for(int i=0;i<array.count;i++){
                                    NSDictionary *dic=[array objectAtIndex:i];
                                    NSString *username=[dic objectForKey:@"username"];
                                    NSString *bduss=[dic objectForKey:@"bduss"];
                                    NSString *tbs=[dic objectForKey:@"tbs"];
                                    NSString *bdnaneimg=[dic objectForKey:@"portrait"];
                                    
                                        if(![localname containsObject:username]){
                                            
                                            UserModel *modelnew=[[UserModel alloc]init];
                                            modelnew.bdname=username;
                                            modelnew.bdnameimage=bdnaneimg;
                                            modelnew.tbs=tbs;
                                            modelnew.bduss=bduss;
                                        //利用Bduss生成新的cookies
                                            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                                            [cookieProperties setObject:@"BDUSS" forKey:NSHTTPCookieName];
                                            [cookieProperties setObject:modelnew.bduss forKey:NSHTTPCookieValue];
                                            [cookieProperties setObject:@".baidu.com" forKey:NSHTTPCookieDomain];
                                            [cookieProperties setObject:@".baidu.com" forKey:NSHTTPCookieOriginURL];
                                            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                                            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                                           // [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];//设置失效时间
                                            [cookieProperties setObject:@"FALSE" forKey:NSHTTPCookieDiscard]; //设置sessionOnly
                                            NSHTTPCookie * cookie01 = [NSHTTPCookie cookieWithProperties:cookieProperties];
                                            NSArray *array=[NSArray arrayWithObjects:cookie01, nil];
                                            modelnew.cookies=[NSArray arrayWithArray:array];
                                            
                                            [newuserArray addObject:modelnew];
                                        
                                        }
                           
                                }
                            }else{
                                for(int i=0;i<array.count;i++){
                                    
                                    NSDictionary *dic=[array objectAtIndex:i];
                                
                                    UserModel *modelnew=[[UserModel alloc]init];
                                    modelnew.bdname=[dic objectForKey:@"username"];
                                   // if(i==0){ CUN_DATA(modelnew.bdname, @"name");}
                                    NSLog(@"download name:%@",modelnew.bdname);
                                    modelnew.bdnameimage=[dic objectForKey:@"portrait"];
                                    modelnew.tbs=[dic objectForKey:@"tbs"];
                                    modelnew.bduss=[dic objectForKey:@"bduss"];
                                     //利用Bduss生成新的cookies
                                     NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                                    [cookieProperties setObject:@"BDUSS" forKey:NSHTTPCookieName];
                                    [cookieProperties setObject:modelnew.bduss forKey:NSHTTPCookieValue];
                                    [cookieProperties setObject:@".baidu.com" forKey:NSHTTPCookieDomain];
                                    [cookieProperties setObject:@".baidu.com" forKey:NSHTTPCookieOriginURL];
                                    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
                                    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
                                   // [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];//设置失效时间
                                    [cookieProperties setObject:@"FALSE" forKey:NSHTTPCookieDiscard]; //设置sessionOnly
                                    NSHTTPCookie * cookie01 = [NSHTTPCookie cookieWithProperties:cookieProperties];
                                    NSArray *array=[NSArray arrayWithObjects:cookie01, nil];
                                    
                                    modelnew.cookies=[NSArray arrayWithArray:array];
                                    [newuserArray addObject:modelnew];
                                    
                                }
                                
                            }
 
                            NSArray *sureArray=[NSArray arrayWithArray:newuserArray];
                            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
                            CUN_DATA(data, @"userinfo");
                            nameArray=[newuserArray copy];
                            [hud hideAnimated:YES];
                            [tableview reloadData];
                            HUD_NAME(@"同步成功！", 0.8);

                        }
                        
                        [hud hideAnimated:YES];
                        HUD_NAME(code, 0.8);
                        
                    }else{
                        [hud hideAnimated:YES];
                        HUD_NAME(@"服务器无您的资料，请上传账号！", 0.8f);
                    }
                    
                    
                }];
                
            }]];
            
            [secondaler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:secondaler animated:YES completion:nil];
            
            
            
        }]];
  
#pragma mark --删除本地所有百度账号
        [aler addAction:[UIAlertAction actionWithTitle:@"删除本地所有百度账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //打开数据库
            FMDBManager *manager = [FMDBManager shareInstance];
            
            NSData *dataold=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
            NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:dataold];
            
            for(UserModel *model in array){
                
                if(![manager.dataBase executeUpdate:[NSString stringWithFormat:@"drop table member%@",model.bdname]]){
                    
                    NSLog(@"删除%@数据表失败",model.bdname);
                }
            }
            
            [nameArray removeAllObjects];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"name"];
            //清理所有cookies
            NSURL *url = [NSURL URLWithString:@"http://wappass.baidu.com/passport/"];
            if (url) {
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
                for (int i = 0; i < [cookies count]; i++) {
                    NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                    [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                }
            }
            NSArray *sureArray=[NSArray arrayWithArray:nameArray];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
            [tableview reloadData];
            
        }]];
        
#pragma mark --退出广为账号
        [aler addAction:[UIAlertAction actionWithTitle:@"退出广为账号" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *signout=[UIAlertController alertControllerWithTitle:@"确定退出广为账号？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [signout addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
                CUN_DATA(nil,@"TheLoginname");
                RootViewController *rootVC=[[RootViewController alloc]init];

                [self.navigationController popToRootViewControllerAnimated:NO];
                [tempAppDelegate.mainVC pushViewController:rootVC animated:YES];
              
            }]];
            [signout addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:signout animated:YES completion:nil];
            
        }]];

        [aler addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:aler animated:YES completion:nil];
    }
}



-(NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@" 0000" withString:@"+0000" options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
}


@end