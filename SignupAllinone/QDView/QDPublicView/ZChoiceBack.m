//
//  ZChoiceBack.m
//  SeaGuest
//
//  Created by 广为网络 on 16/3/4.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "ZChoiceBack.h"

@implementation ZChoiceBack
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        UIScrollView * buttonBackView = [[UIScrollView alloc] initWithFrame:frame];
        buttonBackView.backgroundColor=[UIColor whiteColor];
        buttonBackView.showsHorizontalScrollIndicator=NO;
        buttonBackView.pagingEnabled=NO;
        [self addSubview:buttonBackView];
        self.buttonBackView=buttonBackView;
    }
    return self;
}
- (void)buttonBackArr:(NSArray *)buttonArr
{
    float btn_W = 120;//按钮的宽度
    float btn_H = 35;//按钮的高度
    float btn_JG = 10;//按钮的间隔
    for (int i = 0; i<buttonArr.count; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(btn_JG+(btn_W+btn_JG)*i,(self.buttonBackView.frame.size.height-btn_H)/2,btn_W,btn_H)];
        button.tag=200+i;
        button.backgroundColor=[UIColor orangeColor];
        [button setTitle:[NSString stringWithFormat:@"%@",buttonArr[i]] forState:UIControlStateNormal];
        //靠中对齐
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.clipsToBounds=YES;
        button.layer.cornerRadius=5;
        [button addTarget:self action:@selector(sectionbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonBackView addSubview:button];
    }
    self.buttonBackView.contentSize=CGSizeMake((btn_W+btn_JG)*buttonArr.count+btn_JG, 0);
}
- (void)sectionbuttonClick:(UIButton *)sender
{
    [self removeFromSuperview];
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
    
}
- (void)myShow
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate]window];
    [window addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.myBlock) {
        self.myBlock(1000);
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
