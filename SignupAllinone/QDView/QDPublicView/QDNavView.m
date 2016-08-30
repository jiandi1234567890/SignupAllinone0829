//
//  QDNavView.m
//  GWSignIn
//
//  Created by 广为网络 on 16/4/14.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "QDNavView.h"

@implementation QDNavView
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, PX, 64)];
    if (self) {
        self.backgroundColor=NAV_BG_OLOR;
        self.layer.shadowColor=[UIColor grayColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0,0);
        self.layer.shadowOpacity=1;
        self.layer.shadowRadius=1.0; 
    }
    return self;
}
//添加导航条名字
- (void)navTitleName:(NSString *)titleStr
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    titleLabel.center=CGPointMake(self.center.x, self.center.y+10);
    titleLabel.text=titleStr;
    titleLabel.font=[UIFont systemFontOfSize:20];
    titleLabel.textColor=NAV_NAME_OLOR;
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}

-(void)navTitleName:(NSString *)titleStr andBtnAdd:(SEL)TitleButton{
    
    UIButton * sender  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    sender.center=CGPointMake(self.center.x, self.center.y+10);
    sender.titleLabel.font=[UIFont systemFontOfSize:20];
    [sender setTitle:titleStr forState:UIControlStateNormal];
    [sender setTitleColor:NAV_NAME_OLOR forState:UIControlStateNormal];
    [sender addTarget:self.subviews action:TitleButton forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
    
}


//添加导航条界面
- (void)navTitleView:(UIView *)titleView
{
    titleView.center=CGPointMake(self.center.x,self.center.y+10);
    [self addSubview:titleView];
}
//添加右边按钮
- (void)navRightBtn:(NSString *)btnStr andBtnAdd:(SEL)rightButton
{
    UIButton * sender  = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100,(self.frame.size.height)/2-10, 90,40)];
     sender.titleLabel.font=[UIFont systemFontOfSize:17];
    [sender setTitle:btnStr forState:UIControlStateNormal];
    [sender setTitleEdgeInsets:UIEdgeInsetsMake(0, 90-btnStr.length*17, 0, 0)];
    [sender setTitleColor:NAV_NAME_OLOR forState:UIControlStateNormal];
    [sender addTarget:self.subviews action:rightButton forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
}
//添加右边按钮（图片）
-(void)navRightBtnimage:(UIImage *)image andBtnAdd:(SEL)rightButton
{
    UIButton * sender  = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-100,(self.frame.size.height)/2-10, 90,40)];

    [sender setImage:image forState:UIControlStateNormal];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(5, 60, 5, 0)];
    [sender setTitleColor:NAV_NAME_OLOR forState:UIControlStateNormal];
    [sender addTarget:self.subviews action:rightButton forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];

}

//添加左边按钮（图片）
-(void)navLeftBtnimage:(UIImage *)image andBtnAdd:(SEL)rightButton
{
    UIButton * sender  = [[UIButton alloc] initWithFrame:CGRectMake(10,(self.frame.size.height)/2-10, 90,40)];
    
    [sender setImage:image forState:UIControlStateNormal];
    [sender setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 60)];
    [sender setTitleColor:NAV_NAME_OLOR forState:UIControlStateNormal];
    [sender addTarget:self.subviews action:rightButton forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sender];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
