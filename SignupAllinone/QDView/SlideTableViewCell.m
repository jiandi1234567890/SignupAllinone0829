//
//  SlideTableViewCell.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "SlideTableViewCell.h"

@implementation SlideTableViewCell

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
        self.imageview=[[UIImageView alloc]init];
        self.label=[[UILabel alloc]init];
        self.label.textAlignment=NSTextAlignmentCenter;
        self.label.textColor=[UIColor whiteColor];
    }
    return self;
}

-(void)layoutSubviews{
    
    UILabel *labelline=[[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height ,self.frame.size.width,1)];
    labelline.backgroundColor=[UIColor whiteColor];
    
    self.imageview.frame=CGRectMake(self.frame.size.width/2-20, 5, 40, 40);
    self.label.frame=CGRectMake(0, 50, self.frame.size.width, 20);
    
    [self addSubview:self.imageview];
    [self addSubview:self.label];
    [self addSubview:labelline];
}

@end
