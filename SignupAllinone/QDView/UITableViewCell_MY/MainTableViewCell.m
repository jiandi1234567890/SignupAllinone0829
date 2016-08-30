//
//  MainTableViewCell.m
//  SignUp2
//
//  Created by 张海禄 on 16/7/13.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        self.barID=[[UILabel alloc]init];
        self.barID.textAlignment=NSTextAlignmentCenter;
        self.barID.font=[UIFont systemFontOfSize:16];
        
        self.signcount=[[UILabel alloc]init];
        self.signcount.textAlignment=NSTextAlignmentCenter;
        self.signcount.font=[UIFont systemFontOfSize:16];
        
        self.time=[[UILabel alloc]init];
        self.time.textAlignment=NSTextAlignmentCenter;
        self.time.font=[UIFont systemFontOfSize:16];
        
        
        self.state=[[UILabel alloc]init];
        self.state.textAlignment=NSTextAlignmentCenter;
        self.state.font=[UIFont systemFontOfSize:17];
      

        
    }
    
       return self;
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    

    self.barID.frame=CGRectMake(0, 0, self.bounds.size.width*0.38, self.bounds.size.height);
    self.signcount.frame=CGRectMake(CGRectGetMaxX(self.barID.frame), 0, self.bounds.size.width*0.27, self.bounds.size.height);
    self.time.frame=CGRectMake(CGRectGetMaxX(self.signcount.frame), 0, self.bounds.size.width*0.19, self.bounds.size.height);
    self.state.frame=CGRectMake(CGRectGetMaxX(self.time.frame), 0, self.bounds.size.width*0.16, self.bounds.size.height);
   
    [self addSubview:self.barID];
    [self addSubview:self.signcount];
    [self addSubview:self.time];
    [self addSubview:self.state];
    
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
