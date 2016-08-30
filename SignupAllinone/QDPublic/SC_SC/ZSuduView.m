//
//  ZSuduView.m
//  SignupAllinone
//
//  Created by 广为网络 on 16/6/20.
//  Copyright © 2016年 广为网络. All rights reserved.
//

//屏幕的长
#define PX [[UIScreen mainScreen] bounds].size.width
//屏幕的宽
#define PY [[UIScreen mainScreen] bounds].size.height

#import "ZSuduView.h"

@implementation ZSuduView

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        
        //默认签到线程数为50
        if (QU_DATA(@"QDSHUD")==nil) {
            CUN_DATA(@"50", @"QDSHUD")
        }

        _shulStr=QU_DATA(@"QDSHUD");
        self.backgroundColor =[UIColor colorWithWhite:0.3 alpha:0.7];
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(10, PY/2-80, PX-20, 200)];
        backView.backgroundColor=[UIColor whiteColor];
        backView.clipsToBounds=YES;
        backView.layer.cornerRadius=5;
        [self addSubview:backView];
        
        //标题
        UILabel * biaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20,backView.frame.size.width-20, 25)];
        biaoLabel.text=@"设置签到速度";
        biaoLabel.font=[UIFont systemFontOfSize:20];
        biaoLabel.textColor=[UIColor colorWithRed:14/255.0 green:134/255.0 blue:255/255.0 alpha:1];
        biaoLabel.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:biaoLabel];

        //滑块
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(5, 80, backView.frame.size.width-10, 10)]; //初始化
        slider.minimumValue = 1;//指定可变最小值
        slider.maximumValue = 100;//指定可变最大值
        slider.value = [_shulStr floatValue];//指定初始值
        [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];//设置响应事件
        [backView addSubview:slider];
        
        //线程Label
        _jingduLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, backView.frame.size.width-20, 20)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"签到的线程数为：%@",_shulStr]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:14/255.0 green:134/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(8,_shulStr.length)];
        _jingduLabel.attributedText=str;
        _jingduLabel.font=[UIFont systemFontOfSize:15];
        [backView addSubview:_jingduLabel];

        //按钮
        NSArray * btnArr = @[@"设置",@"取消"];
        float btn_x = 120;
        float btn_y = 40;
        float btn_ox = backView.frame.size.width/btnArr.count/2-btn_x/2;
        float btn_oy = backView.frame.size.height-btn_y-10;
        for (int i = 0; i < btnArr.count; i++) {
            UIButton * addUserBtn = [[UIButton alloc] initWithFrame:CGRectMake(btn_ox+backView.frame.size.width/btnArr.count*i,btn_oy, btn_x, btn_y)];
            addUserBtn.tag=i;
            [addUserBtn setTitle:btnArr[i] forState:UIControlStateNormal];
            [addUserBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            addUserBtn.clipsToBounds=YES;
            addUserBtn.layer.cornerRadius=5;
            addUserBtn.layer.borderColor=[UIColor colorWithRed:14/255.0 green:134/255.0 blue:255/255.0 alpha:1].CGColor;
            addUserBtn.layer.borderWidth=1;
            [addUserBtn addTarget:self action:@selector(addUserBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:addUserBtn];
        }
    }
    return self;
}
//添加响应事件
- (void)updateValue:(UISlider *)sender{
    _shulStr = [NSString stringWithFormat:@"%.0f",sender.value]; //读取滑块的值
    //当为100个线程数时 为极数
    if ([_shulStr isEqualToString:@"100"]) {
        _shulStr = @"不限";
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"签到的线程数为：%@",_shulStr]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:14/255.0 green:134/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(8,_shulStr.length)];
    _jingduLabel.attributedText=str;
    //重复读取 防治不是个数
    _shulStr = [NSString stringWithFormat:@"%.0f",sender.value];
}
- (void)addUserBtnClick:(UIButton *)sender
{
    if (sender.tag==0) {
        CUN_DATA(_shulStr, @"QDSHUD")
    }
    
         [self removeFromSuperview];
}
#pragma mark - 展示
- (void)myshow
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate]window];
    [window addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
