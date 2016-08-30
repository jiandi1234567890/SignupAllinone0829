//
//  BDlist.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/7.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "BDlist.h"

@interface BDlist()

@end

@implementation BDlist

//获取贴吧列表
+(void)getlist{
    
    //清理所有cookies  和设置Cookies
    NSURL *url = [NSURL URLWithString:@"http://wappass.baidu.com/passport/"];
    if (url) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
        for (int i = 0; i < [cookies count]; i++) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    NSString *BDname=[[NSString alloc]init];
    NSArray *cookies=[[NSArray alloc]init];
    //开始获取贴吧时，现将贴吧获取完毕的标志位置否
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"listallget"];
    //根据当前百度账号获取对应的贴吧列表
    BDname=[[NSUserDefaults standardUserDefaults]stringForKey:@"name"];
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if(array.count>0){
        for(UserModel *model in array){
            if([model.bdname isEqualToString:BDname])
            {
                cookies=[model.cookies copy];
            }
        }
    }
    
    NSData *cookiesdata =[NSKeyedArchiver archivedDataWithRootObject:cookies];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        
        NSHTTPCookie *cookie;
        
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
   
    
    NSMutableArray *nameArray=[NSMutableArray new];
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    [manger setSecurityPolicy:securityPolicy];
    
    //2.设置返回数据类型 让其能接收Html数据
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    //打开数据库
    FMDBManager *manager = [FMDBManager shareInstance];
    
    [manger GET:@"http://tieba.baidu.com/f/like/mylike?&pn=1" parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        
        //解析HTML
        TFHpple * doc = [[TFHpple alloc] initWithHTMLData:responseObject];
        
        NSArray * tdArray = [doc searchWithXPathQuery:@"//a"];
        
        //这个数组中就有需要的值
        TFHppleElement * zongEle = [tdArray objectAtIndex:tdArray.count-1];
        //判断是否只有1页的情况
        if ([zongEle.content isEqualToString:@"尾页"]) {
            
            
            if(![manager.dataBase executeUpdate:[NSString stringWithFormat:@"create table if not exists member%@(id integer primary key autoincrement,barname text,level text,rangename text,sign text)",BDname]])
            {
                NSLog(@"创建表失败1");
            }
            
            //不止一页的情况下
            NSString * yeshu = [NSString stringWithFormat:@"%@",[zongEle.attributes objectForKey:@"href"]];
            NSArray  * array= [yeshu componentsSeparatedByString:@"="];
            
            //开辟一个子线程作用作for循环
             dispatch_queue_t group = dispatch_queue_create(nil, nil);
            __block BOOL finish=NO;
            for (int i=1; i<[array[1] intValue]+1; i++) {
             
               dispatch_async(group, ^{
                    
                [manger GET:[NSString stringWithFormat:@"http://tieba.baidu.com/f/like/mylike?&pn=%d",i] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    TFHpple * doc01 = [[TFHpple alloc] initWithHTMLData:responseObject];
                    NSArray * tdArray01 = [doc01 searchWithXPathQuery:@"//tr"];  //这个数组中就有需要的值
                    
                    if ([tdArray01 isKindOfClass:[NSArray class]]&&tdArray01.count>0) {
                        for (int j=1; j<tdArray01.count; j++) {
                            
                            TFHppleElement * trEle01 = [tdArray01 objectAtIndex:j];
                            // 贴吧名称
                            NSArray *tiebaming=[[trEle01.children objectAtIndex:0] children];
                            TFHppleElement * atitleEle01=[[TFHppleElement alloc]init];
                            if(tiebaming.count>1){
                                atitleEle01 = [[[trEle01.children objectAtIndex:0] children] objectAtIndex:1];
                            }else{
                                atitleEle01 = [[[trEle01.children objectAtIndex:0] children] objectAtIndex:0];
                            }
                            //贴吧等级
                            TFHppleElement * aAElement01 =[[[[[trEle01.children objectAtIndex:2] children] objectAtIndex:0] children] objectAtIndex:1];
                            //贴吧内等级名称
                            TFHppleElement *mingcheng=[[[[[trEle01.children objectAtIndex:2] children] objectAtIndex:0] children] objectAtIndex:0];
                            
                            BARModel *barModel=[BARModel new];
                            barModel.barname=atitleEle01.content;
                            barModel.level=[NSString stringWithFormat:@"LV%@",aAElement01.content];
                            barModel.rangename=mingcheng.content;
                            //获取当前关注的贴吧名，之后用作对比
                            [nameArray addObject:barModel.barname];
                            
                            
                            FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@ where barname=(?)",BDname],barModel.barname];
                            
                            if(![rs next]){
                                
                                //将数据写入数据库
                                if (![manager.dataBase executeUpdate:[NSString stringWithFormat:@"insert into member%@(barname,level,rangename,sign) values(?,?,?,?)",BDname],barModel.barname,barModel.level,barModel.rangename,@"未签到"])
                                {
                                    NSLog(@"插入失败1");
                                }else{
                                    
                                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
                                    if(j==(tdArray01.count-1)){
                                        if(i==[array[1] intValue]){
                                            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"listallget"];
                                        }
                                        NSLog(@"%d",i);
                                        finish=YES;
                                    }
                                    
                                }
                            }
                        }
   
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    finish=YES;
                    
                }];
                                    while(1){
                                        //不让此循环卡住主线程
                                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                                        if(finish){
                                            finish=NO;
                                            break;
                                        }
                
                                    }
  });
                
            }
        }else{
            //只要有1页的情况 HTML数据并放回
            TFHpple * doc01 = [[TFHpple alloc] initWithHTMLData:responseObject];
            NSArray * tdArray01 = [doc01 searchWithXPathQuery:@"//tr"];  //这个数组中就有需要的值
            if ([tdArray01 isKindOfClass:[NSArray class]]&&tdArray01.count>0) {
                
                if(![manager.dataBase executeUpdate:[NSString stringWithFormat:@"create table if not exists member%@(id integer primary key autoincrement,barname text,level text,rangename text,sign text)",BDname]])
                {
                    NSLog(@"创建表失败2");
                }
                
                for (int i=1; i<tdArray01.count; i++) {
                    
                    TFHppleElement * trEle01 = [tdArray01 objectAtIndex:i];
                    // 贴吧名称
                    NSArray *tiebaming=[[trEle01.children objectAtIndex:0] children];
                    TFHppleElement * atitleEle01=[[TFHppleElement alloc]init];
                    if(tiebaming.count>1){
                        atitleEle01 = [[[trEle01.children objectAtIndex:0] children] objectAtIndex:1];
                    }else{
                        atitleEle01 = [[[trEle01.children objectAtIndex:0] children] objectAtIndex:0];
                    }
                    
                    //贴吧等级
                    TFHppleElement * aAElement01 =[[[[[trEle01.children objectAtIndex:2] children] objectAtIndex:0] children] objectAtIndex:1];
                    // NSString *levelstring=(NSString *)aAElement01.content;
                    //贴吧内等级名称
                    TFHppleElement *mingcheng=[[[[[trEle01.children objectAtIndex:2] children] objectAtIndex:0] children] objectAtIndex:0];
                    // NSString *mingchenSTR=mingcheng.content;
                    
                    BARModel *barModel=[BARModel new];
                    barModel.barname=atitleEle01.content;
                    barModel.level=[NSString stringWithFormat:@"LV%@",aAElement01.content];
                    barModel.rangename=mingcheng.content;
                    
                    //获取当前关注的贴吧名，之后用作对比
                    [nameArray addObject:barModel.barname];
                    //查询是否添加新贴吧
                    FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@ where barname=(?)",BDname],barModel.barname];
                    
                    if(![rs next]){
                        
                        //将数据写入数据库
                        if (![manager.dataBase executeUpdate:[NSString stringWithFormat:@"insert into member%@(barname,level,rangename,sign) values(?,?,?,?)",BDname],barModel.barname,barModel.level,barModel.rangename,@"未签到"])
                        {
                            NSLog(@"插入失败1");
                        }else
                        {
                            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
                        }
                    }
                    
                }
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"listallget"];
            }
        }
        //查询是否取消关注了贴吧，有就删除
        FMResultSet *rs =  [manager.dataBase executeQuery:[NSString stringWithFormat:@"select * from member%@",BDname]];
        while ([rs next])
        {
            NSString *barname=[rs  stringForColumn:@"barname"];
            NSString *signup=[rs stringForColumn:@"sign"];
            if(![nameArray containsObject:barname]){
                if(![manager.dataBase executeUpdate:[NSString stringWithFormat:@"delete from member%@ where barname=(?)",BDname],barname]){
                    NSLog(@"删除%@吧失败",barname);
                }
            }
            
            if([signup isEqualToString:@"未签到"]){
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
            }
        }
        //获取本地日期,第二天签到状态可以改变了
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"dd"];
        NSString * time=[dateformatter stringFromDate:senddate];
        if([[NSUserDefaults standardUserDefaults]stringForKey:@"signday"]){
            if(![time isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"signday"]]){
                if (![manager.dataBase executeUpdate:[NSString stringWithFormat:@"update member%@  set sign=? ",BDname],@"未签到"]){
                    NSLog(@"重新改状态失败");
                }else{
                    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"allsign"];
                }
            }
        }
        
    }failure:^(NSURLSessionDataTask *task, NSError * error) {
        NSLog(@"error:%@",error);
    }];
}

@end
