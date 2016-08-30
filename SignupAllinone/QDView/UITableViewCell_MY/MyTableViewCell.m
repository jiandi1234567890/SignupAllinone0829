//
//  MyTableViewCell.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "MyTableViewCell.h"
#import "UIView+SDAutoLayout.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor=[UIColor whiteColor];
        //吧名
        self.barname=[[UILabel alloc]init];
        self.barname.textAlignment=NSTextAlignmentLeft;
        //self.barname.font=[UIFont systemFontOfSize:17];
        self.barname.font=[UIFont boldSystemFontOfSize:17];
        //吧内头衔
        self.rangename=[[UILabel alloc]init];
        self.rangename.textColor=[UIColor grayColor];
        self.rangename.textAlignment=NSTextAlignmentLeft;
        self.rangename.font=[UIFont systemFontOfSize:14];
        //等级
        self.level=[[UILabel alloc]init];
        self.level.textAlignment=NSTextAlignmentRight;
        self.level.font=[UIFont systemFontOfSize:14];
        
        //签到状态
        self.signup=[[UILabel alloc]init];
        self.signup.textAlignment=NSTextAlignmentRight;
        self.signup.font=[UIFont systemFontOfSize:16];
        
        
        [self addSubview:self.barname];
        [self addSubview:self.rangename];
        [self addSubview:self.level];
        [self addSubview:self.signup];
        
        
        self.signup.sd_layout
        .rightSpaceToView(self,10)
        .bottomSpaceToView(self,0)
        .heightIs(30)
        .widthIs(60);
        
        self.level.sd_layout
        .rightSpaceToView(self,10)
        .bottomSpaceToView(self.signup,0)
        .heightIs(30)
        .widthIs(60);
        
        
        self.barname.sd_layout
        .topSpaceToView(self,0)
        .leftSpaceToView(self,10)
        .rightSpaceToView(self.signup,5)
        .heightIs(40);
        
        self.rangename.sd_layout
        .topSpaceToView(self.barname,0)
        .leftSpaceToView(self,10)
        .rightSpaceToView(self.signup,5)
        .heightIs(30);
        
        
        
        
        
        
        
    }
    
    return self;
    
    
}



@end
