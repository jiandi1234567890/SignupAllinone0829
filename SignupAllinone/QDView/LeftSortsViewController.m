//
//  LeftSortsViewController.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/19.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "RootViewController.h"
#import "CountTimeViewController.h"
#import "ZSuduView.h"

@interface LeftSortsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableview;
    NSArray *_settingArray;
}

@end


@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"slideBackground"];
    [self.view addSubview:imageview];

   // _settingArray=[NSArray arrayWithObjects:@"使用说明",@"注册手机,启动云服务",@"从tet文件导入账号",@"导出账号",@"设置不签到ID",@"免费升级VIP",@"分享给其他人",@"给开发作者好评点赞",@"积分商城",@"一键回帖",@"定时签到",@"去广告",@"检查更新", nil];
    _settingArray=[NSArray arrayWithObjects:@"使用说明",@"注册手机,启动云服务",@"设置不签到ID",@"给开发作者好评点赞",@"定时签到",@"设置签到速度",@"检查更新", nil];

    
    UITableView *tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableview = tableview;
    tableview.dataSource=self;
    tableview.delegate=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableview.tableFooterView=[[UIView alloc]init];
    tableview.tableHeaderView=[self viewfortableviewHeader];
   // _tableview.bounces=NO;
    [self.view addSubview:tableview];
    
}

-(UIView *)viewfortableviewHeader{
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableview.bounds.size.width, _tableview.bounds.size.height*0.1)];
    
    view.backgroundColor=[UIColor clearColor];
    UILabel *label=[[UILabel alloc]init];
    label.text=@"设置";
    label.textColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
    label.font=[UIFont boldSystemFontOfSize:18];
    label.textAlignment=NSTextAlignmentCenter;
    label.frame=CGRectMake(0, 24, view.bounds.size.width-120, view.bounds.size.height-24);
    [view addSubview:label];
    return view;

    
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    return _tableview.bounds.size.height*0.1;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view=[[UIView alloc]init];
//    view.backgroundColor=[UIColor clearColor];
//    UILabel *label=[[UILabel alloc]init];
//    label.text=@"设置";
//    label.textColor=[UIColor colorWithRed:0.16 green:0.78 blue:0.98 alpha:1.00];
//    label.font=[UIFont boldSystemFontOfSize:18];
//    label.textAlignment=NSTextAlignmentCenter;
//    label.frame=CGRectMake(0, 24, _tableview.bounds.size.width, _tableview.bounds.size.height*0.1-24);
//    [view addSubview:label];
//    
//    return view;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _settingArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
       cell.textLabel.text=_settingArray[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
       return cell;
    
    
}

#pragma mark --侧栏界面跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //取消选中时高亮状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController *vc = nil;
    
            switch (indexPath.row) {
        case 0:
          vc=[[InstructionsViewController alloc]init];
            break;
            
        case 1:{
                    if (QU_DATA(@"TheLoginname")!=nil) {
                        vc=[[ChangenameViewController alloc]init];

                    }else{
                        vc=[[RootViewController alloc]init];}
                }
            break;
        case 2:
             vc=[[NosignViewController alloc]init];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://appsto.re/cn/G_vEbb.i"]];
            break;
        case 4:
                    vc=[[CountTimeViewController alloc]init];

          break;
         case 5:{
             ZSuduView *view=[[ZSuduView alloc]init];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [view myshow];
             });

         }
            break;
        case 6:[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://appsto.re/cn/G_vEbb.i"]];
                    
            break;
//        case 7:
//            break;
//        case 8:
//                    
//            break;
//        case 9:
//                    
//            break;
//        case 10:
//            break;
//        case 11:
//                    
//            break;
//         case 12:
//                    
//            break;
            
        default:
            break;
    }
        //等一段时间再把侧栏隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
   });

    UINavigationController *navC = nil;
    navC=tempAppDelegate.mainVC;
    [navC pushViewController:vc animated:YES];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
