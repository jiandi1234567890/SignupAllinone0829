//
//  loginRequest.h
//  signup-allinone
//
//  Created by 张海禄 on 16/6/13.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Base64.h"
#import "AFNetworking.h"

@interface loginRequest : NSObject
//获取验证码
+ (void)SecurityCodeRequest:(NSString *)phonenumber andStyle:(NSString *)styleStr andBlock:(void(^)(NSString * SecurityCodeX))block;

//注册
+ (void)RegisterRequest:(NSString *)phonenumber andPass:(NSString *)password andSecurityCode:(NSString *)code andSecurityCodeX:(NSString *)SecurityCodeXStr andBlock:(void(^)(NSDictionary * dic))block;

//登录
+ (void)LoginRequest:(NSString *)phonenumber andPass:(NSString *)password andBlock:(void(^)(NSString * string))block;


//找回密码
+(void)FindBackRequest:(NSDictionary *)zhaoDic andBlock:(void(^)(NSString * string))block;

//修改密码
+(void)ChangeCodeRequest:(NSString *)ssid andOldCode:(NSString *)oldpassword  andNewCode:(NSString *)newpassword  andBlock:(void(^)(NSString * string))block;



//上传用户列表
+(void)UpLoadUserInformatiaonWithDIC:(NSDictionary *)dic andBlock:(void(^)(NSString * string))block;
//下载用户列表

+(void)DownLoadUserInformatiaonWithSesid:(NSDictionary *)sesidDic andBlock:(void(^)(id responseObject))block;

@end
