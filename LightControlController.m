//
//  LightControlController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightControlController.h"
#import "SLSlideMenu.h"
#import "SlideMenuesViewController.h"
#import "Light.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface LightControlController ()<UITableViewDelegate,UITableViewDataSource,SlideMenuesViewDataDelegate>

{
    BOOL isLighting;
    float percent;
    int isOpen;
    
}

@property(nonatomic,strong)UIBarButtonItem *menues;

@property(nonatomic,strong)UIImageView *lightView;

@property(nonatomic,strong)SlideMenuesViewController *slideMenuesViewController;

@property(nonatomic,strong)NSMutableArray *offLineTitles;
@property(nonatomic,strong)NSMutableArray *onLineTitles;
@property(nonatomic,strong) Light *light;

@end

@implementation LightControlController

#pragma mark 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.estimatedRowHeight = 60;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    CGRect viewf=self.view.frame;
    CGRect tablf=self.tableView.frame;
//    [self.tableView sizeToFit];
    self.slideMenuesViewController=[[SlideMenuesViewController alloc]init];
    [self addChildViewController:_slideMenuesViewController];
    [self initTopView];
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    self.tableView.tableFooterView=footView;
    self.onLineTitles=[NSMutableArray arrayWithObjects:@"路灯名称",@"在线状态",@"工作模式",@"安装位置",@"路灯开关",@"路灯亮度",nil];
    self.offLineTitles=[NSMutableArray arrayWithObjects:@"路灯名称",@"在线状态",@"工作模式",@"安装位置",nil];
    
}

-(void)initTopView
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.2)];
    
    self.lightView=[[UIImageView alloc]initWithFrame:CGRectMake((topView.frame.size.width-topView.frame.size.height)/2, 0, topView.frame.size.height, topView.frame.size.height)];
    self.lightView.image=[UIImage imageNamed:@"lamp"];
    [topView addSubview:self.lightView];
    self.tableView.tableHeaderView=topView;
    
    
    UIBarButtonItem *refreshButtionItem=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"refresh_light"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(lightStateRefresh)];
    self.navigationItem.leftBarButtonItem=refreshButtionItem;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"路灯控制";
    self.menues=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStyleDone target:self action:@selector(clickMenu)];
    [self.navigationItem setRightBarButtonItem:self.menues];
}

#pragma mark 路灯状态刷新
-(void)lightStateRefresh
{
    if (self.light!=nil&&self.light.gwid!=nil&&self.light.lampnum!=nil) {
        NSDictionary *params=@{@"deviceCode":self.light.gwid,
                               @"lampNum":self.light.lampnum};
        NSLog(@"%@",params);
        [self showLoaddingTip:@"正在刷新"];
        [[HttpTool sharedInstance]Post:@"/api/query" params:params success:^(id responseObj) {
            if (responseObj) {
                BOOL isSuccess=[[responseObj valueForKey:@"success"]boolValue];
                if (isSuccess) {
                    NSData *resultData=[[responseObj valueForKey:@"result"] dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *err;
                    NSDictionary *result=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:&err];
                    if (err) {
                        NSLog(@"json解析失败：%@",err);
                    }else{
                        self.light.workstate=[[result valueForKey:@"workState"]intValue];
                        self.light.workmode=[result valueForKey:@"workMode"];
                        self.light.light=[[result valueForKey:@"light"]intValue];
                        [self.tableView reloadData];
                        [self dissmissTips];
                        [self showSuccessTip:@"刷新成功" timeOut:0.3f];
                    }
                    
                }else{
                    [self dissmissTips];
                    [self getExceptionInfo:[responseObj valueForKey:@"msg"]];
                }
                
            }
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            [self dissmissTips];
            [self showFailureTip:@"程序或网络异常" detail:nil timeOut:0.3f];
        } platform:RequestTypePlatformCommunication];
        
    }else if (self.light==nil){
        [self showMessageTip:@"路灯信息不能为空" detail:nil timeOut:0.3f];
    }else if (self.light.gwid==nil){
        [self showMessageTip:@"网关不能为空" detail:nil timeOut:0.3f];
    }else if (self.light.lampnum==nil){
        [self showMessageTip:@"路灯编码不能为空" detail:nil timeOut:0.3f];
    }
    
}

//菜单点击
-(void)clickMenu
{
    float slideWidth=screenW*0.8;
    float offset=screenW-slideWidth;
    CGRect frame=self.view.frame;
    [self.slideMenuesViewController.tableView registerNib:[UINib nibWithNibName:@"SlideMenuCel" bundle:nil] forCellReuseIdentifier:@"SlideMenuCelId"];
    [SLSlideMenu slideMenuWithFrame:CGRectMake(0, 0, slideWidth, screenH)
                           delegate:self.slideMenuesViewController
                          direction:SLSlideMenuDirectionRight
                        slideOffset:offset
                allowSwipeCloseMenu:YES
                           aboveNav:YES
                         identifier:@"right"
                             object:self.menues];
}

#pragma mark tableview协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.light) {
        //判断是否有路灯信息
        if (self.light.lightId!=nil) {
            //判断路灯手动或者自动
            if (self.light.workmode!=nil&& [self.light.workmode isEqualToString:@"03"]) {
                return self.onLineTitles.count;
            }else{
                return self.offLineTitles.count;
            }
        }else{
            return 0;
        }
        
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //判断是否有路灯信息
    if (self.light!=nil&&self.light.lightId!=nil) {
        //手动模式
        if ((self.light.workmode!=nil)&&[self.light.workmode isEqualToString:@"03"]) {
            if (indexPath.row==4) {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
                //cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UILabel *titleLabel=[cell viewWithTag:1000];
                titleLabel.text=self.onLineTitles[indexPath.row];
                //控制灯开关
                UISwitch *lightSwitch=[cell viewWithTag:1100];
                if (self.light.lampstate==0) {
                    //离线
                    [lightSwitch setOn:NO];
                    lightSwitch.enabled=false;
                }else if(self.light.lampstate==1){
                    //在线
                    if (self.light.workstate==0) {
                        [lightSwitch setOn:YES];
                    }
                    if (self.light.workstate==1) {
                        [lightSwitch setOn:NO];
                    }
                    [lightSwitch addTarget:self action:@selector(clickLightSwitch:) forControlEvents:UIControlEventValueChanged];
                }
                return cell;
            }else if (indexPath.row==5) {
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UILabel *titleLabel=[cell viewWithTag:1000];
                titleLabel.text=self.onLineTitles[indexPath.row];
                //灯亮度
                UISlider *lightSlider=[cell viewWithTag:1100];
                if ((self.light.lampstate==0)||(self.light.workstate==1)) {
                    //离线
                    lightSlider.value=percent;
                    lightSlider.enabled=NO;
                    UILabel *percentLabel=[cell viewWithTag:1200];
                    percentLabel.text=[NSString stringWithFormat:@"%@ %",[self getPercence:percent]];
                }else if((self.light.lampstate==1)||(self.light.workstate==0)){
                    //在线
                    lightSlider.value=percent;
                    lightSlider.enabled=YES;
                    //判断路灯是否可以控制亮度
                    lightSlider.continuous=NO;//默认YES  如果设置为NO，则每次滑块停止移动后才触发事件
                    [lightSlider addTarget:self action:@selector(controllerLightLinghting:) forControlEvents:UIControlEventValueChanged];
                    UILabel *percentLabel=[cell viewWithTag:1200];
                    percentLabel.text=[NSString stringWithFormat:@"%@ %",[self getPercence:percent]];
                }
                
                return cell;
            }else{
                UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                UILabel *titleLabel=[cell viewWithTag:1000];
                titleLabel.text=self.onLineTitles[indexPath.row];
                UILabel *valueLabel=[cell viewWithTag:1100];
                switch (indexPath.row) {
                    case 0:
                        valueLabel.text=self.light.title;
                        break;
                    case 1:
                        if (self.light.lampstate==0) {
                            valueLabel.text=@"离线";
                            valueLabel.textColor=[UIColor redColor];
                        }
                        if (self.light.lampstate==1) {
                            valueLabel.text=@"在线";
                            valueLabel.textColor=[UIColor greenColor];
                        }
                        break;
                    case 2:
                        if ([self.light.workmode isEqualToString:@"00"]) {
                            valueLabel.text=@"纯光控";
                        }
                        if ([self.light.workmode isEqualToString:@"01"]) {
                            valueLabel.text=@"光控+时控";
                        }
                        if ([self.light.workmode isEqualToString:@"02"]) {
                            valueLabel.text=@"定时";
                        }
                        if ([self.light.workmode isEqualToString:@"03"]) {
                            valueLabel.text=@"手动";
                        }
                        if ([self.light.workmode isEqualToString:@"04"]) {
                            valueLabel.text=@"晨亮";
                        }
                        break;
                    case 3:
                        valueLabel.numberOfLines=0;
                        valueLabel.text=self.light.lightAddress;
                        break;
                        
                    default:
                        break;
                }
                return cell;
            }
        }else{
            UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
            UILabel *titleLabel=[cell viewWithTag:1000];
            titleLabel.text=self.onLineTitles[indexPath.row];
            UILabel *valueLabel=[cell viewWithTag:1100];
            switch (indexPath.row) {
                case 0:
                    valueLabel.text=self.light.title;
                    break;
                case 1:
                    if (self.light.lampstate==0) {
                        valueLabel.text=@"离线";
                        valueLabel.textColor=[UIColor redColor];
                    }
                    if (self.light.lampstate==1) {
                        valueLabel.text=@"在线";
                        valueLabel.textColor=[UIColor greenColor];
                    }
                    break;
                case 2:
                    valueLabel.text=@"";
                    break;
                case 3:
                    valueLabel.numberOfLines=0;
                    valueLabel.text=self.light.lightAddress;
                    break;
                    
                default:
                    break;
            }
            return cell;
        }
    }else{
        return [tableView dequeueReusableCellWithIdentifier:@"cell3"];
    }
}


#pragma mark 侧滑菜单数据回调协议
-(void)reloadLightInfo:(Light *)light
{
    if (light) {
        self.light=light;
        if (self.light.workstate==0) {
            self.lightView.image=[UIImage imageNamed:@"lamp_l"];
        }else if(self.light.workstate==1){
            self.lightView.image=[UIImage imageNamed:@"lamp"];
        }
        
        NSLog(@"路灯id:%@",light.lightId);
        percent=(float)self.light.light/100;
        [self.tableView reloadData];
    }
}

#pragma mark 路灯开关
-(void)clickLightSwitch:(UISwitch *)sender
{
    BOOL *is=[sender isOn];
    
    NSLog(@"服务平台的server url:%@",[HttpTool sharedInstance].serverUrl);
    //测试网络联通性
    [self showLoaddingTip:@"开始配置" timeOut:0.5f];
    [[HttpTool sharedInstance] Post:checkNetSocket params:nil success:^(id responseObj) {
        if (responseObj) {
            if ([[responseObj valueForKey:@"success"]boolValue]) {
                //网络连接成功,进行路灯开关控制
                if (is) {
                    //1.开路灯
                    [self lightOpenControl:1 withLight:100];
                    
                }else{
                    //2.关路灯
                    [self lightOpenControl:2 withLight:0];
                }
                
            }else{
                //网络连接失败
                if ([[responseObj valueForKey:@"msg"] isEqualToString:@"1"]) {
                    [self showFailureTip:@"集中器不在线" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"2"]){
                    [self showFailureTip:@"网络超时" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"3"]){
                    [self showFailureTip:@"数据处理异常" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"4"]){
                    [self showFailureTip:@"集中器ID为空" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"5"]){
                    [self showFailureTip:@"路灯编码为空" detail:nil timeOut:0.3f];
                }else{
                    [self showFailureTip:@"后台异常" detail:nil timeOut:0.3f];
                }

            }
            NSLog(@"responseObj:%@",responseObj);
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [self showFailureTip:@"网络异常" detail:nil timeOut:0.3f];
        }
    } platform:RequestTypePlatformCommunication];
    
   
}
//路灯开关控制
-(void)lightOpenControl:(int)loadswitchstate withLight:(int)light
{
    //loadswitchstate 1:开 2:关
    //参数拼接
    NSString *params=[NSString stringWithFormat:@"?deviceCode=%@&lampNum=%@&workMode=%@&loadswitchstate=%d&light=%d",self.light.gwid,self.light.lampnum,self.light.workmode,loadswitchstate,light];
    //网络请求
    [[HttpTool sharedInstance] Get:lightModel params:params success:^(id responseObj) {
        if (responseObj) {
            if ([[responseObj valueForKey:@"success"]boolValue]) {
                
                if (loadswitchstate==1) {
                    //开
                    [self showSuccessTip:@"路灯已打开" timeOut:0.3f];
                    self.light.workstate=0;
                    self.light.light=light;
                    percent=(float)light/100;
                     self.lightView.image=[UIImage imageNamed:@"lamp_l"];
                }else if(loadswitchstate==2){
                    //关
                    [self showSuccessTip:@"路灯已关闭" timeOut:0.3f];
                    self.light.workstate=1;
                    self.light.light=light;
                    percent=(float)light/100;
                     self.lightView.image=[UIImage imageNamed:@"lamp"];
                    
                }
                NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:4 inSection:0];
                NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:5 inSection:0];
                NSArray *indexPaths=@[indexPath1,indexPath2];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                
            }else{
                //失败
                if ([[responseObj valueForKey:@"msg"] isEqualToString:@"1"]) {
                    [self showFailureTip:@"集中器不在线" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"2"]){
                    [self showFailureTip:@"网络超时" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"3"]){
                    [self showFailureTip:@"数据处理异常" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"4"]){
                    [self showFailureTip:@"集中器ID为空" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"5"]){
                    [self showFailureTip:@"路灯编码为空" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"6"]){
                    [self showFailureTip:@"硬件型号不匹配" detail:nil timeOut:0.3f];
                }else{
                    [self showFailureTip:@"后台异常" detail:nil timeOut:0.3f];
                }
                
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            [self showFailureTip:@"网络异常" detail:nil timeOut:0.3f];
        }
    } platform:RequestTypePlatformCommunication];

}
#pragma mark 控制路灯亮度
-(void)controllerLightLinghting:(UISlider *)sender
{
    UISlider *slider=(UISlider *)sender;
    self.light.light=sender.value;
    percent=sender.value;
    
    
    //测试网络联通性
    [self showLoaddingTip:@"开始配置" timeOut:0.5f];
    [[HttpTool sharedInstance] Post:checkNetSocket params:nil success:^(id responseObj) {
        if (responseObj) {
            if ([[responseObj valueForKey:@"success"]boolValue]) {
                //网络连接成功,进行路灯亮度控制
                [self setLightLighting:[[self getPercence:sender.value]intValue]];
            }else{
                //网络连接失败
                if ([[responseObj valueForKey:@"msg"] isEqualToString:@"1"]) {
                    [self showFailureTip:@"集中器不在线" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"2"]){
                    [self showFailureTip:@"网络超时" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"3"]){
                    [self showFailureTip:@"数据处理异常" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"4"]){
                    [self showFailureTip:@"集中器ID为空" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"5"]){
                    [self showFailureTip:@"路灯编码为空" detail:nil timeOut:0.3f];
                }else{
                    [self showFailureTip:@"后台异常" detail:nil timeOut:0.3f];
                }

            }
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [self showFailureTip:@"网络异常" detail:nil timeOut:0.3];
        }
    } platform:RequestTypePlatformCommunication];
    
}
//路灯亮度控制
-(void)setLightLighting:(int)light
{
    //参数拼接
    int loadswitchstate=0;
    if (self.light.workstate==0) {
        loadswitchstate=1;
    }else if(self.light.workstate==1){
        loadswitchstate=2;
    }
    
    NSString *params=[NSString stringWithFormat:@"?deviceCode=%@&lampNum=%@&workMode=%@&light=%d&loadswitchstate=%d",self.light.gwid,self.light.lampnum,self.light.workmode,light,loadswitchstate];
    //网络请求
    [[HttpTool sharedInstance] Get:lightModel params:params success:^(id responseObj) {
        if (responseObj) {
            if ([[responseObj valueForKey:@"success"]boolValue]) {
                [self showSuccessTip:@"配置成功" timeOut:0.3f];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
                NSArray *indexPaths=@[indexPath];
                [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }else{
                //失败
                if ([[responseObj valueForKey:@"msg"] isEqualToString:@"1"]) {
                    [self showFailureTip:@"集中器不在线" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"2"]){
                    [self showFailureTip:@"网络超时" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"3"]){
                    [self showFailureTip:@"数据处理异常" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"4"]){
                    [self showFailureTip:@"集中器ID为空" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"5"]){
                    [self showFailureTip:@"路灯编码为空" detail:nil timeOut:0.3f];
                }else if([[responseObj valueForKey:@"msg"] isEqualToString:@"6"]){
                    [self showFailureTip:@"硬件型号不匹配" detail:nil timeOut:0.3f];
                }else{
                    [self showFailureTip:@"后台异常" detail:nil timeOut:0.3f];
                }

            }
        }
    } failure:^(NSError *error) {
        if (error) {
            [self showFailureTip:@"网络异常" detail:nil timeOut:0.3f];
        }
    } platform:RequestTypePlatformCommunication];
    
}
#pragma mark 懒加载
-(Light *)light
{
    if (_light==nil) {
        _light=[[Light alloc]init];
    }
    return _light;
}

#pragma mark 其他
-(NSString *)getPercence:(float)num
{
    NSNumber *lightNumber=[NSNumber numberWithFloat:num];
    ;
    return [NSNumberFormatter localizedStringFromNumber:lightNumber numberStyle:NSNumberFormatterPercentStyle];

}

-(void)getExceptionInfo:(NSString *)msg
{
    //网络连接失败
    if ([msg isEqualToString:@"1"]) {
        [self showFailureTip:@"集中器不在线" detail:nil timeOut:0.3f];
    }else if([msg isEqualToString:@"2"]){
        [self showFailureTip:@"网络超时" detail:nil timeOut:0.3f];
    }else if([msg isEqualToString:@"3"]){
        [self showFailureTip:@"数据处理异常" detail:nil timeOut:0.3f];
    }else if([msg isEqualToString:@"4"]){
        [self showFailureTip:@"集中器ID为空" detail:nil timeOut:0.3f];
    }else if([msg isEqualToString:@"5"]){
        [self showFailureTip:@"路灯编码为空" detail:nil timeOut:0.3f];
    }else{
         [self showFailureTip:@"后台异常" detail:nil timeOut:0.3f];
    }
}
@end
