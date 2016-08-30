//
//  UserModel.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/2.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.bduss forKey:@"BDuss"];
    [aCoder encodeObject:self.bdname forKey:@"BDname"];
    [aCoder encodeObject:self.bdnameimage forKey:@"image"];
    [aCoder encodeObject:self.tbs forKey:@"tbs"];
    [aCoder encodeObject:self.cookies forKey:@"cookies"];
    [aCoder encodeBool:self.noneedsign forKey:@"noneedsign"];
    [aCoder encodeBool:self.sign forKey:@"sign"];
    [aCoder encodeObject:self.signtime forKey:@"signtime"];
   // [aCoder encodeBool:self.needsign forKey:@"needsign"];
    [aCoder encodeObject:self.barnumber forKey:@"barnumber"];
    
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super init];
    if(self){
        self.bduss=[aDecoder decodeObjectForKey:@"BDuss"];
        self.bdname=[aDecoder decodeObjectForKey:@"BDname"];
        self.bdnameimage=[aDecoder decodeObjectForKey:@"image"];
        self.tbs=[aDecoder decodeObjectForKey:@"tbs"];
        self.cookies=[aDecoder decodeObjectForKey:@"cookies"];
        self.noneedsign=[aDecoder decodeBoolForKey:@"noneedsign"];
        self.sign=[aDecoder decodeBoolForKey:@"sign"];
        self.signtime=[aDecoder decodeObjectForKey:@"signtime"];
        //self.needsign=[aDecoder decodeBoolForKey:@"needsign"];
        self.barnumber=[aDecoder decodeObjectForKey:@"barnumber"];
       
    }
    return self;
}

@end














