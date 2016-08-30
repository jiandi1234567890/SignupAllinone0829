//
//  loginRequest.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/13.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "loginRequest.h"


@implementation loginRequest

//获取验证码
+ (void)SecurityCodeRequest:(NSString *)phonenumber andStyle:(NSString *)styleStr andBlock:(void(^)(NSString * SecurityCodeX))block{
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
   
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:phonenumber,@"phone",styleStr,@"type", nil];
    
    [manger POST:@"http://apptest.gnwai.com/sign/index.php/Cgi/Login/get_vcode" parameters:dataDic progress:nil  success:^(NSURLSessionDataTask * task, id responseObject) {
       
        
        NSString * SecurityCodeX = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"data"] objectForKey:@"revsesid"] ];
        
        if (block) {
            block(SecurityCodeX);
        }

    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        if(block){
            block(nil);
        }
        NSLog(@"获取验证码失败:%@",error);
    }];

}


//注册
+(void)RegisterRequest:(NSString *)phonenumber andPass:(NSString *)password andSecurityCode:(NSString *)SecurityCode andSecurityCodeX:(NSString *)SecurityCodeXStr andBlock:(void(^)(NSDictionary * dic))block{
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:phonenumber,@"phone",password,@"password",SecurityCode,@"vcode",SecurityCodeXStr,@"revsesid", nil];
    
    [manger POST:@"http://apptest.gnwai.com/sign/index.php/Cgi/Login/register" parameters:dataDic progress:nil success:^(NSURLSessionDataTask * task, id responseObject) {
        //NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       // NSString * loginstatus= [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"errcode"] ];
        if (responseObject) {
            block(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"注册失败：%@",error);
    }];
    
}

//登录
+ (void)LoginRequest:(NSString *)phonenumber andPass:(NSString *)password andBlock:(void(^)(NSString * string))block{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:phonenumber,@"phone",password,@"password", nil];
    
    [manger POST:@"http://apptest.gnwai.com/sign/index.php/Cgi/login/login" parameters:dataDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * error_code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error_code"]];
        NSString * sesid = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"data"] objectForKey:@"sesid"]];
        CUN_DATA(sesid, @"SESID");
        
        if (block) {
            block(error_code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//修改密码
+(void)ChangeCodeRequest:(NSString *)sesid andOldCode:(NSString *)oldpassword  andNewCode:(NSString *)newpassword  andBlock:(void(^)(NSString * string))block
{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:sesid,@"sesid",oldpassword,@"old_passwd",newpassword,@"new_passwd", nil];
    
    [manger POST:@"http://apptest.gnwai.com/sign/index.php//Cgi/Login/change_passwd" parameters:dataDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * errcode = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error_code"]];
        if (block) {
            block(errcode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//找回密码
+(void)FindBackRequest:(NSDictionary *)zhaoDic andBlock:(void(^)(NSString * string))block
{
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    [manger POST:@"http://apptest.gnwai.com/sign/index.php/Cgi/Login/re_passwd" parameters:zhaoDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * error_code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error_code"]];
//        [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]];
        if (block) {
            block(error_code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            block(nil);
        }
    }];
}

//上传用户列表
+(void)UpLoadUserInformatiaonWithDIC:(NSDictionary *)dic andBlock:(void(^)(NSString * string))block{
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
//    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manger POST:@"http://apptest.gnwai.com/sign/index.php/Cgi/Index/user_add" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSString * error_code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error_code"]];
   NSString *string=[NSString stringWithFormat:@"%@",responseObject];
    //NSString * dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"response:%@",string);
        if (block) {
            block(error_code);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *string=[NSString stringWithFormat:@"%@",error];
        
        if (block) {
            block(string);
        }
    }];

    
}



//下载用户列表

+(void)DownLoadUserInformatiaonWithSesid:(NSDictionary *)sesidDIC andBlock:(void (^)(id responseObject))block{
    
    
    AFHTTPSessionManager * manger = [AFHTTPSessionManager manager];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;

    [manger POST:@"http://apptest.gnwai.com/sign/index.php/Cgi/Index/get_user_list" parameters:sesidDIC progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  NSString * error_code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"error_code"]];
        //NSString *string=[NSString stringWithFormat:@"%@",responseObject];
       
        if (block) {
            block(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        if (block) {
            block(nil);
        }
    }];
    
    
}



@end
