//
//  UserModel.h
//  signup-allinone
//
//  Created by 张海禄 on 16/6/2.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>
@property(nonatomic,copy) NSString *bdname;
@property(nonatomic,copy) NSString *bdnameimage;
@property(nonatomic,copy) NSString *bduss;
@property(nonatomic,copy) NSString *tbs;
@property(nonatomic,strong) NSArray * cookies;
//签到标志位
@property(nonatomic)BOOL sign;
//是否要签到
//@property(nonatomic,strong) NSString * needsign;
@property(nonatomic)BOOL noneedsign;
//贴吧数量
@property(nonatomic,strong) NSString * barnumber;
//签到时间
@property(nonatomic,strong) NSString * signtime;
@end
