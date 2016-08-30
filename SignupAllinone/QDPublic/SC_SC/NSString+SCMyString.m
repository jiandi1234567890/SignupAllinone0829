//
//  NSString+SCMyString.m
//  GWSignIn
//
//  Created by 广为网络 on 16/4/19.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "NSString+SCMyString.h"

@implementation NSString (SCMyString)
//通过此方法加密的事32位的
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}
//将32位的MD字符串 转化成16位的M的字符串
+ (NSString *)trransFromMD532ToMD516:(NSString *)MD532{
    NSString  * string;
    for (int i=0; i<24; i++) {
        string=[MD532 substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    //    电信号段:133/153/180/181/189/177
    //    联通号段:130/131/132/155/156/185/186/145/176
    //    移动号段:134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
    //    虚拟运营商:170
    if(mobileNum.length!=11){
        return NO;
    }else{
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[06-8])\\d{8}$";
        
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
        
        return [regextestmobile evaluateWithObject:mobileNum];
    }
}
@end
