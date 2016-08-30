//
//  SlidebarView.m
//  signup-allinone
//
//  Created by 张海禄 on 16/6/16.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "SlidebarView.h"
#import "SlideTableViewCell.h"

@interface SlidebarView ()
{
    NSArray *array1;
    NSArray *array2;
}

@end


@implementation SlidebarView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor whiteColor];
        self.layer.shadowColor=[UIColor grayColor].CGColor;
        self.layer.shadowOffset=CGSizeMake(0, 0);
        self.layer.shadowOpacity=1;
        self.layer.shadowRadius=1;

        UIView *navView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 64)];
        navView.backgroundColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
        [self addSubview:navView];
        
        UILabel *navLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, 44)];
        navLabel.text=@"菜单";
        navLabel.textAlignment=NSTextAlignmentCenter;
        navLabel.font=[UIFont boldSystemFontOfSize:18];
        navLabel.textColor=[UIColor whiteColor];
        
        [navView addSubview:navLabel];
        
        self.mytableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, frame.size.width, frame.size.height-64)];
        self.mytableview.backgroundColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
        self.mytableview.delegate=self;
        self.mytableview.dataSource=self;
        array1=@[@"一键签到",@"账号管理",@"定时签到",@"修改密码",@"退出账号"];
        array2=@[@"icon_menu_onekeysign.png",@"icon_menu_account.png",@"icon_menu_clock.png",@"icon_menu_reply.png",@"zhe_nav_jump_page_arrow.png"];
        
        self.mytableview.separatorStyle=UITableViewCellSeparatorStyleNone;
        [self addSubview:self.mytableview];
    }
    return self;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return array1.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor whiteColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SlideTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell=[[SlideTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
    
    cell.imageview.image=[UIImage imageNamed:array2[indexPath.row]];
    cell.label.text=array1[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            self.signBlock();
            break;
        case 1:
            self.memberBlock();
            break;
        case 2:
            self.timeBlock();
            break;
        case 3:
            self.changecodeBlock();
            break;
        case 4:
            self.signoutBlock();
            break;
        default:
            break;
    }
}

//按键提醒显示
-(void)showMessage:(NSString *)message withtime:(CGFloat) time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.alpha = 0.8f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize=[message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 999) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} context:nil].size;
    label.text = message;
    label.numberOfLines=0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    
    showview.frame = CGRectMake(20, ([UIScreen mainScreen].bounds.size.height)/2,[UIScreen mainScreen].bounds.size.width-40, LabelSize.height+10);
    label.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-40-LabelSize.width)/2, 5, LabelSize.width, LabelSize.height);
    
    [showview addSubview:label];
    [UIView animateWithDuration:time  animations:^{showview.alpha=0.0f;}    completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}


@end
