//
//  BDsign.h
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/11.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "UserModel.h"
#import "BARModel.h"
#import "FMDBManager.h"


@interface BDsign : NSObject

//单个贴吧签到
+(void)signSinglewithBarname:(NSString *)barname  andBDUSS:(NSString *)bduss andTBS:(NSString *)tbs andBlock:(void (^)(NSString *state))block;



@end
