//
//  FMDBManager.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/3.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "FMDBManager.h"

@implementation FMDBManager
+ (instancetype)shareInstance
{
    static FMDBManager *manager = nil;
    
    //@synchronized  互斥锁
    //一次只允许一个线程访问锁起的代码
    //参数,放一个不会销毁的对象
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [[FMDBManager alloc]init];
        }
    }
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化数据库
        NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/tiebalist.db"];
        
       // NSLog(@"filePath==%@",filePath);
        
        //有数据库就读取,没有就创建
        self.dataBase = [FMDatabase databaseWithPath:filePath];
        
        if (![self.dataBase open])
        {
            NSLog(@"数据库打开失败");
        }
              
    }
    return self;
}

@end
