//
//  CountTimeViewController.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/12.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "CountTimeViewController.h"

@interface CountTimeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSArray *hours,*minutes;
    NSString *hour,*minute;
    NSArray *timeArray;
}
@property (nonatomic, strong)UIPickerView *picker;//选择器
@property (nonatomic, strong)UIView *pickerBG;//选择器底
@end

@implementation CountTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"设定时间";
    self.view.backgroundColor=[UIColor whiteColor];
    hour=[NSString new];
    minute=[NSString new];
    
    
    UILabel *noticelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    noticelabel.numberOfLines=0;
    noticelabel.text=@"该功能暂未实现\n仅有设置界面！！！";
    noticelabel.textColor=[UIColor redColor];
    noticelabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:noticelabel];
    
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];

    if(array.count>0){
    
    timeArray=[[NSUserDefaults standardUserDefaults]arrayForKey:@"timeArray"];
    if(timeArray!=nil){
        //有签到时间时，显示签到时间及修改和删除签到时间按钮
        NSString *timeString=[NSString stringWithFormat:@"定时签到时间：%@:%@",timeArray[0],timeArray[1]];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, 50)];
        timeLabel.text=timeString;
        timeLabel.textAlignment=NSTextAlignmentCenter;
       
        UIButton *changetime=[UIButton buttonWithType:UIButtonTypeSystem];
        changetime.frame=CGRectMake(50, 220, 100, 40);
        [changetime setTitle:@"修改签到时间" forState:UIControlStateNormal];
        [changetime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        changetime.backgroundColor=[UIColor orangeColor];
        changetime.layer.cornerRadius=8;
        changetime.layer.masksToBounds=YES;
        [changetime addTarget:self action:@selector(addtime) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *deletetime=[UIButton buttonWithType:UIButtonTypeSystem];
        deletetime.frame=CGRectMake(self.view.frame.size.width-150, 220, 100, 40);
        [deletetime setTitle:@"删除签到时间" forState:UIControlStateNormal];
        [deletetime setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deletetime.backgroundColor=[UIColor redColor];
        deletetime.layer.cornerRadius=8;
        deletetime.layer.masksToBounds=YES;
        [deletetime addTarget:self action:@selector(deletetime) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:timeLabel];
        [self.view addSubview:changetime];
        [self.view addSubview:deletetime];
        
    }else{
        
        //无签到时间，时显示添加签到按钮
        UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
        button.frame=CGRectMake(50, 150, self.view.frame.size.width-100, 50);
        [button setTitle:@"添加定时签到时间" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor=[UIColor orangeColor];
        button.layer.cornerRadius=8;
        button.layer.masksToBounds=YES;
        
        [button addTarget:self action:@selector(addtime) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    }else{
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 50)];
        timeLabel.text=@"请先登录百度账号";
        timeLabel.textAlignment=NSTextAlignmentCenter;

        [self.view addSubview:timeLabel];
    }
}

-(void)addtime{
    
    if (self.pickerBG != nil) {
        [self.pickerBG removeFromSuperview];
        self.pickerBG = nil;
    }
    [self.view addSubview:self.pickerBG];
    [UIView animateWithDuration:0.4 animations:^{
        self.pickerBG.frame = CGRectMake(0, (self.view.frame.size.height-64)/3*2-30, self.view.frame.size.width, (self.view.frame.size.height-64)/3+30);
    }];
    
}

-(void)deletetime{
    
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"timeArray"];
    
    //删除子视图 保留父视图
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    [self viewDidLoad];
    
}

-(UIView *)pickerBG
{
    if(!_pickerBG){
        _pickerBG = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height-64)/3+30)];
        _pickerBG.backgroundColor = [UIColor whiteColor];
        
        _picker=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 70,_pickerBG.frame.size.width, _pickerBG.frame.size.height-40)];
        _picker.delegate=self;
        _picker.dataSource=self;
        hours=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        
        minutes=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
        
        UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,_pickerBG.frame.size.width, 40)];
        
        UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishedAction:)];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        // [finishItem setTintColor:[UIColor blackColor]];
        [doneToolbar setItems:[NSArray arrayWithObjects:finishItem, flexItem,cancelItem,nil] animated:NO];
        
        UILabel *labelleft=[[UILabel alloc]initWithFrame:CGRectMake(0, 40, _pickerBG.frame.size.width/2, 30)];
        labelleft.text=@"小时";
        labelleft.textAlignment=NSTextAlignmentCenter;
        
        UILabel *labelright=[[UILabel alloc]initWithFrame:CGRectMake(_pickerBG.frame.size.width/2, 40, _pickerBG.frame.size.width/2, 30)];
        labelright.textAlignment=NSTextAlignmentCenter;
        labelright.text=@"分钟";
        
        timeArray=[[NSUserDefaults standardUserDefaults]arrayForKey:@"timeArray"];
        
        if(timeArray!=nil){
            NSInteger hourcount=[timeArray[0] integerValue];
            NSInteger minutecount=[timeArray[1] integerValue];
            [_picker selectRow:hourcount inComponent:0 animated:NO];
            [_picker selectRow:minutecount inComponent:1 animated:NO];
            
            hour=timeArray[0];
            minute=timeArray[1];
        }else{
            hour=hours[0];
            minute=minutes[0];
        }
        
        [_pickerBG addSubview:doneToolbar];
        [_pickerBG addSubview:labelright];
        [_pickerBG addSubview:labelleft];
        [_pickerBG addSubview:_picker];
    }
    return _pickerBG;
}



//pickview 完成按键
- (void)finishedAction:(id)sender
{
    __weak CountTimeViewController *weakSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        weakSelf.pickerBG.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        
        
        NSArray *timearray=[NSArray arrayWithObjects:hour,minute, nil];
        [[NSUserDefaults standardUserDefaults]setObject:timearray forKey:@"timeArray"];
        
    [weakSelf.pickerBG removeFromSuperview];
    weakSelf.pickerBG = nil;
        
        //删除子视图 保留父视图
        [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
        [self viewDidLoad];

    }];
}

//pickview 取消按键

- (void)cancelAction:(id)sender
{
    __weak CountTimeViewController *weakSelf = self;
    [UIView animateWithDuration:0.4f animations:^{
        weakSelf.pickerBG.frame = CGRectMake(0, weakSelf.view.frame.size.height, weakSelf.view.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [weakSelf.pickerBG removeFromSuperview];
        weakSelf.pickerBG = nil;
        
    }];
}



#pragma mark UIPickerViewDataSource
//返回UIPickerView一共有几列
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0){
        return hours.count;
    }else return minutes.count;
}




-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component==0){
        return hours[row];
    }else return minutes[row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component==0){
        
        hour=hours[row];
    }else minute=minutes[row];
    
    
}



@end
