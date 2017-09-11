//
//  SysSettingController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import "SysSettingController.h"
#import "SysInfoUpdate.h"

 NSString * const  cellId=@"cellId";


@interface SysSettingController ()<UITableViewDelegate,UITableViewDataSource,SysInfoUpdateDelegate>


@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) NSArray *cellIcons;


@end

@implementation SysSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    self.titles=@[@"密码修改",@"版本更新",@"参数配置"];
    self.cellIcons=@[@"key_set",@"up_set",@"ip_set"];
    
self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    CGRect tableFrame=self.tableView.frame;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.edgesForExtendedLayout = UIRectEdgeNone;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

#pragma mark 视图加载
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationItem.title=@"系统控制";
    self.navigationController.navigationBar.hidden=YES;
    //tableview
   // self.tableView.backgroundColor=[UIColor yellowColor];
    
    //顶部视图
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenFrame.size.width, ScreenFrame.size.height/3)];
    UIImageView *backGroundView=[[UIImageView alloc]initWithFrame:topView.frame];
    backGroundView.image=[UIImage imageNamed:@"bg_set"];
    [topView addSubview:backGroundView];
    //logo
    float logoViewWidth=ScreenFrame.size.width*0.2;
    float logoViewHeight=logoViewWidth;
    UIImageView *logoView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenFrame.size.width/2-logoViewWidth/2, topView.frame.size.height/2-logoViewHeight/2, logoViewWidth, logoViewHeight)];
    logoView.image=[UIImage imageNamed:@"user_set"];
    [topView addSubview:logoView];
    CGRect topviewF=topView.frame;
    self.tableView.tableHeaderView=topView;
    
    //底部视图
    
    UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
    //footView.backgroundColor=[UIColor redColor];
    
    UIButton *tuiChuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    int tuiChuBtnWidth=ScreenWidth-30;
    int tuiChuBtnHeight=footView.frame.size.height/2;
    tuiChuBtn.frame=CGRectMake((ScreenWidth-tuiChuBtnWidth)/2, tuiChuBtnHeight/2, tuiChuBtnWidth, tuiChuBtnHeight);
    [tuiChuBtn setTitle:@"退出" forState:UIControlStateNormal];
    [tuiChuBtn setTintColor:[UIColor whiteColor]];
    [tuiChuBtn setBackgroundColor:RGB(0, 205, 102)];
    tuiChuBtn.layer.cornerRadius=10;
    [footView addSubview:tuiChuBtn];
    //添加点击事件
    [tuiChuBtn addTarget:self action:@selector(tuiChu) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView=footView;
    
    
}

//用户退出
-(void)tuiChu
{
    [self presentViewController:[ViewTool initViewByStoryBordName:@"Login" withViewId:@"login"] animated:YES completion:^{
        [[User sharedInstance] clearUser];
    }];
}

#pragma mark 协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.titles>0) {
        return self.titles.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *identity=cellId;
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identity];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identity];
    }
    if (self.titles.count>0) {
        cell.textLabel.text=self.titles[indexPath.row];
        cell.imageView.image=[UIImage imageNamed:self.cellIcons[indexPath.row]];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        SysInfoUpdate *sysInfoViewController=[ViewTool initViewByStoryBordName:@"SystemSetting" withViewId:@"sysInfo"];
        sysInfoViewController.delegate=self;
        sysInfoViewController.sysInfoType=SysSettingTypeUpdatePwd;
        sysInfoViewController.title=self.titles[indexPath.row];
        [self.navigationController pushViewController:sysInfoViewController animated:YES];
    }
    if(indexPath.row==1){
        [self showMessageTip:@"暂无更新" detail:nil timeOut:0.3f];
    }
    if (indexPath.row==2) {
        SysInfoUpdate *sysInfoViewController=[ViewTool initViewByStoryBordName:@"SystemSetting" withViewId:@"sysInfo"];
        sysInfoViewController.sysInfoType=SysSettingTypeUpdateParams;
        sysInfoViewController.title=self.titles[indexPath.row];
        [self.navigationController pushViewController:sysInfoViewController animated:YES];
    }
}

#pragma mark 更新密码协议
-(void)isUpdatePwd:(BOOL)isSuccess
{
    [self tuiChu];
}


@end
