//
//  BDlist.h
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/7.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UserModel.h"
#import "BARModel.h"
#import "FMDBManager.h"
#import "TFHpple.h"
@interface BDlist : NSObject
//获取贴吧列表
+(void)getlist;
@end
