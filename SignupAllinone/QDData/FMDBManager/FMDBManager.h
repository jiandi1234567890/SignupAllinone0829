//
//  FMDBManager.h
//  signup-allinone
//
//  Created by 张海禄 on 16/6/3.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBManager : NSObject
//假如APP有十几个页面,每个页面都要进行数据库的读写操作
//如果每个页面都去打开,关闭数据库,会变得很繁琐,效率低下
//所以将它封装成一个单例,便于你在任何一个地方取到它
@property (nonatomic,strong)FMDatabase *dataBase;

//instancetype  == id
//获取单例的方法
+ (instancetype)shareInstance;



@end
