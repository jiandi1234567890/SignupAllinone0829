//
//  BDsign.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/11.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "BDsign.h"

@implementation BDsign

+(void)signSinglewithBarname:(NSString *)barname andBDUSS:(NSString *)bduss andTBS:(NSString *)tbs andBlock:(void (^)(NSString *state))block{
    
    
    NSString * Md5Str = [NSString stringWithFormat:@"BDUSS=%@_client_id=03-00-DA-59-05-00-72-96-06-00-01-00-04-00-4C-43-01-00-34-F4-02-00-BC-25-09-00-4E-36_client_type=4_client_version=1.2.1.17_phone_imei=540b43b59d21b7a4824e1fd31b08e9a6kw=%@net_type=3tbs=%@tiebaclient!!!",bduss,barname,tbs];
    // 替换字符串中的其中一个字符
    NSString * TiStr = [Md5Str stringByReplacingOccurrencesOfString:@"&" withString:@""];
    NSString * MD5STR32 =[NSString md5:TiStr];
    NSString * DAMD5STR32 = [MD5STR32 uppercaseString];
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:bduss,@"BDUSS",@"03-00-DA-59-05-00-72-96-06-00-01-00-04-00-4C-43-01-00-34-F4-02-00-BC-25-09-00-4E-36",@"_client_id",@"4",@"_client_type",@"1.2.1.17",@"_client_version",@"540b43b59d21b7a4824e1fd31b08e9a6",@"_phone_imei",@"3",@"net_type",barname,@"kw",tbs,@"tbs",DAMD5STR32,@"sign",nil];
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    //打开数据库
    FMDBManager *db = [FMDBManager shareInstance];
    
    [manger POST:@"http://c.tieba.baidu.com/c/c/forum/sign" parameters:dataDic progress:nil  success:^(NSURLSessionDataTask * task, id responseObject) {
        if(![db.dataBase executeUpdate:[NSString stringWithFormat:@"update member%@ set sign=(?) where barname=(?)",[[NSUserDefaults standardUserDefaults]stringForKey:@"name"]],@"已签到",barname])
        {
            NSLog(@"%@吧修改状态不成功",barname);
        }
       
        if(block){
            block(@"success");
        }
        
    }failure:^(NSURLSessionDataTask * task, NSError *error) {
              if(block){
            block(@"failure");
        }

       
    }];
    
    
}


@end
