//
//  NosignViewController.m
//  SignupAllinone
//
//  Created by 张海禄 on 16/7/18.
//  Copyright © 2016年 广为网络. All rights reserved.
//

#import "NosignViewController.h"
#import "UIKit+AFNetworking.h"
#import "UserModel.h"

@interface NosignViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_userArray;
    UITableView *tableview;
}

@end

@implementation NosignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *data=[[NSUserDefaults standardUserDefaults]dataForKey:@"userinfo"];
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithData:data];

    _userArray=[NSMutableArray arrayWithArray:array];
   self.navigationItem.title=@"设置不签到ID";
    self.view.backgroundColor=[UIColor whiteColor];
    tableview=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.tableFooterView=[[UIView alloc]init];
    if ([tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableview setLayoutMargins:UIEdgeInsetsZero];
    }

    
    [self.view addSubview:tableview];
    
    
    
}


#pragma mark － UITableviewDatasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    UserModel *model=_userArray[indexPath.row];
    
    NSURL *url=[NSURL URLWithString:model.bdnameimage];
    NSString *string=[NSString stringWithFormat:@"%@",model.bdname];
    
    [cell.imageView setImageWithURL:url];
    cell.textLabel.text=string;
    
    if(model.noneedsign){
        
        cell.detailTextLabel.textColor=[UIColor redColor];
        cell.detailTextLabel.text=@"不签到";
    }else{
        cell.detailTextLabel.text=@"";
    }
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==(_userArray.count-1)){
        [tableview reloadData];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    
    UserModel *model=_userArray[indexPath.row];
    
    if(model.noneedsign){
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"取消该账号不签到状态？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            model.noneedsign=NO;
            [_userArray replaceObjectAtIndex:indexPath.row withObject:model];
            NSArray *sureArray=[NSArray arrayWithArray:_userArray];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
            [tableview reloadData];
            
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"设定该账号不签到？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            model.noneedsign=YES;
            [_userArray replaceObjectAtIndex:indexPath.row withObject:model];
            NSArray *sureArray=[NSArray arrayWithArray:_userArray];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:sureArray];
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"userinfo"];
            [tableview reloadData];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
    
 
    
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
