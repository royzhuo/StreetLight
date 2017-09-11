//
//  SlideMenuesViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/16.
//  Copyright © 2017年 street. All rights reserved.
//

#import "SlideMenuesViewController.h"
#import "SLSlideMenu.h"
#import "MenuGroup.h"
#import "Privince.h"
#import "Cities.h"
#import "Area.h"
#import "Light.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "UITableView+MoreInfo.h"
#import "SlideMenuCell.h"
#import "CityBtn.h"

#import "LightControlController.h"
@interface SlideMenuesViewController()<UITableViewDelegate,UITableViewDataSource>
{
    float slideMenuWidth;
    
}

@property(nonatomic,strong)UILabel *diQuTopLabel;
@property(nonatomic,strong)UITableView *menueTableView;
@property(nonatomic,strong)UILabel *weiFenZhuLabel;
@property(nonatomic,strong)NSMutableArray *qitas;//装顶级区域以外的东西
@property(nonatomic,strong)NSMutableArray *menuGroups;
@end

@implementation SlideMenuesViewController


-(void)viewDidLoad
{

    
    [self.view addSubview:self.tableView];
    
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
    }
    return self;
}
#pragma mark 侧滑菜单协议
-(void)slideMenu:(SLSlideMenu *)slideMenu prepareSubviewsForMenuView:(UIView *)menuView
{
    CGRect menuvf=menuView.frame;
    slideMenuWidth=slideMenu.frame.size.width;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, menuView.frame.size.width, 64)];
    titleView.backgroundColor=[UIColor grayColor];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=@"路灯选择";
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    [menuView addSubview:titleView];
    
    self.tableView.frame=CGRectMake(0, titleView.frame.origin.y+titleView.frame.size.height, menuView.frame.size.width, menuView.frame.size.height-titleView.frame.size.height-titleView.frame.origin.y);
    [menuView addSubview:self.tableView];
//    
//    [self getTopDiquview];
//    [self getWeiFenZuView];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SlideMenuCell" bundle:nil] forCellReuseIdentifier:@"SlideMenuCellId"];
    //网络请求
    [self loadMenuData];
}

//加载路灯顶级区域视图
-(void)getTopDiquview
{
    UIView *cellMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, slideMenuWidth, 44)];
    //图标
    UIButton *iconView=[UIButton buttonWithType:UIButtonTypeCustom];
    [iconView setImage:[UIImage imageNamed:@"shiqu"] forState:UIControlStateNormal];
    iconView.frame=CGRectMake(0, 10,15 ,15);
    [iconView setBackgroundColor:[UIColor whiteColor]];
    [cellMenuView addSubview:iconView];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width, 0, (slideMenuWidth-iconView.frame.origin.x-iconView.frame.size.width-15)*0.7, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickGetTopAreaData) forControlEvents:UIControlEventTouchUpInside];
    
    self.diQuTopLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, (44-20)/2, button.frame.size.width, 20)];
    [self.diQuTopLabel setBackgroundColor:[UIColor clearColor]];
    [self.diQuTopLabel setFont:[UIFont systemFontOfSize:14]];
    [button addSubview:self.diQuTopLabel];
    //线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, cellMenuView.frame.size.height-1, cellMenuView.frame.size.width, 1)];
    [line setImage:[UIImage imageNamed:@"line_real"]];
    [button addSubview:line];
    
    [cellMenuView addSubview:button];
    
    self.tableView.tableHeaderView=cellMenuView;
    
}
//加载未分组视图
-(void) getWeiFenZuView
{
    UIView *cellMenuView=[[UIView alloc]initWithFrame:CGRectMake(0,0, slideMenuWidth, 44)];
    //图标
    UIButton *iconView=[UIButton buttonWithType:UIButtonTypeCustom];
    [iconView setImage:[UIImage imageNamed:@"shiqu"] forState:UIControlStateNormal];
    iconView.frame=CGRectMake(0, 10,15 ,15);
    [iconView setBackgroundColor:[UIColor whiteColor]];
    [cellMenuView addSubview:iconView];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width, 0, (slideMenuWidth-iconView.frame.origin.x-iconView.frame.size.width-15)*0.7, 44)];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickGetWeiFenZuData) forControlEvents:UIControlEventTouchUpInside];
    self.weiFenZhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, (44-20)/2, button.frame.size.width, 20)];
    [self.weiFenZhuLabel setBackgroundColor:[UIColor clearColor]];
    [self.weiFenZhuLabel setFont:[UIFont systemFontOfSize:14]];
    [button addSubview:self.weiFenZhuLabel];
    //线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, cellMenuView.frame.size.height-1, cellMenuView.frame.size.width, 1)];
    [line setImage:[UIImage imageNamed:@"line_real"]];
    [button addSubview:line];
    
    [cellMenuView addSubview:button];
    
    self.tableView.tableFooterView=cellMenuView;
    
}

-(void) loadMenuData
{
    if (self.menuGroups.count>0) {
        [self.menuGroups removeAllObjects];
    }
    if (self.qitas.count>0) {
        [self.qitas removeAllObjects];
    }
    BOOL isViewLight=true;
    NSString *params=[NSString stringWithFormat:@"?isViewLight=%@&toKen=%@&inccode=%@",isViewLight?@"true":@"false",[User sharedInstance].token,[User sharedInstance].inccode];
    [self showLoaddingTip:@"加载路灯信息....."];
    [[HttpTool sharedInstance]Get:getRegion params:params success:^(id responseObj) {
        if (responseObj) {
            NSLog(@"response:%@",responseObj);
            BOOL isSuccess=[[responseObj valueForKey:@"success"]boolValue];
            if (isSuccess) {
                NSArray *results=[responseObj valueForKey:@"result"];
                for (NSDictionary *result in results) {
                    //1.处理分组
                    if ([[result valueForKey:@"pId"]isEqualToString:@""]) {
                            MenuGroup *menuGroup=[[MenuGroup alloc]initWithId:[result valueForKey:@"id"] withPid:[result valueForKey:@"pId"] withLevel:([[result valueForKey:@"level"]intValue]) withIsRegion:([[result valueForKey:@"isRegion"]boolValue]) withName:[result valueForKey:@"name" ]];
                        menuGroup.isClicked=NO;
                        [self.menuGroups addObject:menuGroup];
                    }else{
                        [self.qitas addObject:result];
                    }
                }
                //2.处理省 以及路灯
                NSMutableArray *tempPri=[NSMutableArray array];//用户清理掉 qitas集合中包含省的dic
                for (MenuGroup *menuGroup in self.menuGroups) {
                    for (NSDictionary *dic in self.qitas) {
                        if ([[dic valueForKey:@"pId"] isEqualToString:menuGroup.menuGroupId]) {
                            if ([[dic valueForKey:@"name"] containsString:@"省"]) {
                                Privince *privince=[[Privince alloc]initPrivinceWithId:[dic valueForKey:@"id"] withPrivinceName:[dic valueForKey:@"name"] withRegion:[[dic valueForKey:@"level"]intValue] withLevel:[[dic valueForKey:@"isRegion"]boolValue] withParentId:[dic valueForKey:@"pId"]];
                                privince.isClicked=NO;
                                if (menuGroup.privinces==nil) {
                                    menuGroup.privinces=[NSMutableArray array];
                                }
                                [menuGroup.privinces addObject:privince];
                                [tempPri addObject:dic];
                            }else if ([[dic valueForKey:@"name"] containsString:@"市"]) {
                                Cities *city=[[Cities alloc]initCityWithId: [dic valueForKey:@"id"] withCityName:[dic valueForKey:@"name"] withRegion:[[dic valueForKey:@"isRegion"]boolValue] withLevel:[[dic valueForKey:@"level"]intValue] withParentId:[dic valueForKey:@"pId"]];
                                city.isClicked=NO;
                                if (menuGroup.cities==nil) {
                                    menuGroup.cities=[NSMutableArray array];
                                }
                                [menuGroup.cities addObject:city];
                                [tempPri addObject:dic];
                            }else{
                                if (menuGroup.lights==nil) {
                                    menuGroup.lights=[NSMutableArray array];
                                }
                                if ([menuGroup.name isEqualToString:@"路灯前端顶级区域"]) {
                                    Light *light=[[Light alloc]initWithLightId:[dic valueForKey:@"id"] withPId:[dic valueForKey:@"pId"] withAddress:[dic valueForKey:@"address"] withLamnum:[dic valueForKey:@"lampnum"] withIsRegion:[[dic valueForKey:@"isRegion"]boolValue] withName:[dic valueForKey:@"name"] withWorkMode:[dic valueForKey:@"workmode"] withLampstate:([[dic valueForKey:@"lampstate"]intValue]) withGwid:[dic valueForKey:@"gwid"] withLight:([[dic valueForKey:@"light"]intValue]) withLampwork:([[dic valueForKey:@"lampwork"]intValue]) withWorkstate:([[dic valueForKey:@"workstate"]intValue])];
                                    [menuGroup.lights addObject:light];
                                    [tempPri addObject:dic];
                                }
                                if ([menuGroup.name isEqualToString:@"未分组区域"]) {
                                    Light *light=[[Light alloc]initWithLightId:[dic valueForKey:@"id"] withPId:[dic valueForKey:@"pId"] withAddress:[dic valueForKey:@"address"] withLamnum:[dic valueForKey:@"lampnum"] withIsRegion:[[dic valueForKey:@"isRegion"]boolValue] withName:[dic valueForKey:@"name"] withWorkMode:nil withLampstate:nil withGwid:[dic valueForKey:@"gwid"] withLight:nil withLampwork:([[dic valueForKey:@"lampwork"]intValue]) withWorkstate:([[dic valueForKey:@"workstate"]intValue])];
                                    [menuGroup.lights addObject:light];
                                    [tempPri addObject:dic];
                                }

                            }
                            
                        }
                    }
                }
                [self.qitas removeObjectsInArray:tempPri];
                //3.处理市区
                NSMutableArray *tempCity=[NSMutableArray array];//同理清除qitas中有关城市的数据
                for (MenuGroup *menugroup in self.menuGroups) {
                    if ([menugroup.name isEqualToString:@"路灯前端顶级区域"]) {
                        //遍历省
                        for (Privince *privince in menugroup.privinces) {
                            for (NSDictionary *dic in self.qitas) {
                                if ([[dic valueForKey:@"pId"] isEqualToString:privince.selfId]) {
                                    if ([[dic valueForKey:@"name"] containsString:@"市"]) {
                                        if (privince.citys==nil) {
                                            privince.citys=[NSMutableArray array];
                                        }
                                        Cities *city=[[Cities alloc]initCityWithId: [dic valueForKey:@"id"] withCityName:[dic valueForKey:@"name"] withRegion:[[dic valueForKey:@"isRegion"]boolValue] withLevel:[[dic valueForKey:@"level"]intValue] withParentId:[dic valueForKey:@"pId"]];
                                        city.isClicked=NO;
                                        [privince.citys addObject:city];
                                        [tempCity addObject:dic];
                                    }else{
                                        if (privince.lights==nil) {
                                            privince.lights=[NSMutableArray array];
                                        }
                                       Light *light=[[Light alloc]initWithLightId:[dic valueForKey:@"id"] withPId:[dic valueForKey:@"pId"] withAddress:[dic valueForKey:@"address"] withLamnum:[dic valueForKey:@"lampnum"] withIsRegion:[[dic valueForKey:@"isRegion"]boolValue] withName:[dic valueForKey:@"name"] withWorkMode:[dic valueForKey:@"workmode"] withLampstate:([[dic valueForKey:@"lampstate"]intValue]) withGwid:[dic valueForKey:@"gwid"] withLight:([[dic valueForKey:@"light"]intValue]) withLampwork:([[dic valueForKey:@"lampwork"]intValue]) withWorkstate:([[dic valueForKey:@"workstate"]intValue])];
                                        [privince.lights addObject:light];
                                        [tempCity addObject:dic];
                                    }
                                }
                            }
                        }
                        [self.qitas removeObjectsInArray:tempCity];
                        if (menugroup.cities!=nil&&menugroup.cities.count>0) {
                            //遍历和省同级的城市
                            for (Cities *city in menugroup.cities) {
                                for (NSDictionary *dic in self.qitas) {
                                    if ([[dic valueForKey:@"pId"] isEqualToString:city.selfId]) {
                                        //判断是否是县或区
                                        if ((![[dic valueForKey:@"name"] containsString:@"县"])||(![[dic valueForKey:@"name"] containsString:@"区"])) {
                                            Light *light=[[Light alloc]initWithLightId:[dic valueForKey:@"id"] withPId:[dic valueForKey:@"pId"] withAddress:[dic valueForKey:@"address"] withLamnum:[dic valueForKey:@"lampnum"] withIsRegion:[[dic valueForKey:@"isRegion"]boolValue] withName:[dic valueForKey:@"name"] withWorkMode:[dic valueForKey:@"workmode"] withLampstate:([[dic valueForKey:@"lampstate"]intValue]) withGwid:[dic valueForKey:@"gwid"] withLight:([[dic valueForKey:@"light"]intValue]) withLampwork:([[dic valueForKey:@"lampwork"]intValue]) withWorkstate:([[dic valueForKey:@"workstate"]intValue])];
                                            if (city.lights==nil) {
                                                city.lights=[NSMutableArray array];
                                            }
                                            [city.lights addObject:light];
                                            [tempCity addObject:dic];
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
                [self.qitas removeObjectsInArray:tempCity];
                
                //4.处理区域
                NSMutableArray *tempArea=[NSMutableArray array];//同理清除qitas中有关区域的信息
                for (MenuGroup *menugroup in self.menuGroups) {
                    if ([menugroup.name isEqualToString:@"路灯前端顶级区域"]) {
                        //遍历省
                        for (Privince *privince in menugroup.privinces) {
                            //遍历市
                            for (Cities *city in privince.citys) {
                                for (NSDictionary *dic in self.qitas) {
                                    if ([[dic valueForKey:@"pId"] isEqualToString:city.selfId]) {
                                        Area *area=[[Area alloc]initAreaWithId:[dic valueForKey:@"id"] withAreaName:[dic valueForKey:@"name"] withRegion:[[dic valueForKey:@"isRegion"]boolValue] withLevel:[[dic valueForKey:@"level"]intValue] withParentId:[dic valueForKey:@"pId"]];
                                        area.isClicked=NO;
                                        if (city.areas==nil) {
                                            city.areas=[NSMutableArray array];
                                        }
                                        [city.areas addObject:area];
                                        [tempArea addObject:dic];
                                    }
                                }
                            }
                        }
                    }
                }
                [self.qitas removeObjectsInArray:tempArea];
//                //5.判断区下面是否有路灯
                //更新数据
                NSLog(@"%@",self.menuGroups);
                MenuGroup *firstMenuGroup=self.menuGroups[0];
                if (firstMenuGroup.secondDatas==nil) {
                    firstMenuGroup.secondDatas=[NSMutableArray array];
                }
                //处理省下面城市和路灯的集合
                if (firstMenuGroup.privinces!=nil&&firstMenuGroup.privinces.count>0) {
                    [firstMenuGroup.secondDatas addObjectsFromArray:firstMenuGroup.privinces];
                    for (Privince *privince in firstMenuGroup.privinces) {
                        if (privince.thirdDatas==nil) {
                            privince.thirdDatas=[NSMutableArray array];
                        }
                        if (privince.citys!=nil&&privince.citys.count>0) {
                            [privince.thirdDatas addObjectsFromArray:privince.citys];
                        }
                        if (privince.lights!=nil&&privince.lights.count>0) {
                            [privince.thirdDatas addObjectsFromArray:privince.lights];
                        }
                    }
                }
                //处理分组下面路灯和城市集合        
                if (firstMenuGroup.cities!=nil&&firstMenuGroup.cities.count>0) {
                    [firstMenuGroup.secondDatas addObjectsFromArray:firstMenuGroup.cities];
                }
                if (firstMenuGroup.lights!=nil&&firstMenuGroup.lights.count>0) {
                    [firstMenuGroup.secondDatas addObjectsFromArray:firstMenuGroup.lights];
                }
                [self dissmissTips];
                [self showSuccessTip:@"加载完成" timeOut:0.3f];
                [self.tableView reloadData];
            }else{
                [self dissmissTips];
                [self showFailureTip:@"加载失败" detail:nil timeOut:0.3f];
                int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                if (tokenCode!=0) {
                    [SLSlideMenu dismiss];
                    [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                }
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [self dissmissTips];
            [self showFailureTip:@"网络异常" detail:nil timeOut:0.3f];
            
        }
    }];


}
#pragma mark tableview协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView tableViewDisplayWitMsg:@"没有数据" ifNecessaryForRowCount:self.menuGroups.count];
    if (self.menuGroups.count>0) {
        return   self.menuGroups.count;
    }else {
        return 0;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.menuGroups.count>0) {
        MenuGroup *group=self.menuGroups[section];
        if (section==0) {
            if (group.isClicked==YES) {
                return group.secondDatas.count;
            }else{
                return 0;
            }
        }else{
            if (group.isClicked==YES) {
                return group.lights.count;
            }else{
                return 0;
            }
        }
    }else {
        return 0;
    }
   
   
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SlideMenuCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SlideMenuCellId"];
    MenuGroup *menuGroup=self.menuGroups[indexPath.section];
    CityBtn *citybtn=(CityBtn *)cell.jiantouBtn;
    citybtn.indexPath=indexPath;
    citybtn.hidden=YES;
    if (indexPath.section==0) {
        NSArray *secondDatas=menuGroup.secondDatas;
        if ([secondDatas[indexPath.row] isKindOfClass:[Privince class]]) {
            Privince *privince=secondDatas[indexPath.row];
            [cell.iconBtn setImage:[UIImage imageNamed:@"dingwei_icon"] forState:UIControlStateNormal];
             cell.menuLabel.text=privince.name;
            if (privince.citys!=nil&&privince.citys.count>0) {
                citybtn.hidden=NO;
                if(privince.isClicked==NO){
                    [citybtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
                }
                if (privince.isClicked==YES) {
                    [citybtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
                }
                [citybtn addTarget:self action:@selector(clickGetCities:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else if ([secondDatas[indexPath.row] isKindOfClass:[Cities class]]) {
            Cities *city=secondDatas[indexPath.row];
            [cell.iconBtn setImage:[UIImage imageNamed:@"dingwei_icon"] forState:UIControlStateNormal];
            cell.menuLabel.text=city.name;
            NSLog(@"分组id:%@",menuGroup.menuGroupId);
            if ([city.parentId isEqualToString:menuGroup.menuGroupId]==true) {
                if(city.lights!=nil&&city.lights.count>0){
                    citybtn.hidden=NO;
                    if (city.isClicked==NO) {
                        [citybtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
                    }
                    if(city.isClicked==YES){
                        [citybtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
                    }
                    [citybtn addTarget:self action:@selector(clickCityGetLights:) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }else{
                if (city.areas!=nil&&city.areas>0) {
                    citybtn.hidden=NO;
                    if (city.isClicked==NO) {
                        [citybtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
                    }else{
                        [citybtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
                    }
                    [citybtn addTarget:self action:@selector(clickGetAreas:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else if ([secondDatas[indexPath.row] isKindOfClass:[Area class]]) {
            Area *area=secondDatas[indexPath.row];
            [cell.iconBtn setImage:[UIImage imageNamed:@"dingwei_icon"] forState:UIControlStateNormal];
            cell.menuLabel.text=area.name;
        }else if ([secondDatas[indexPath.row] isKindOfClass:[Light class]]) {
            Light *light=secondDatas[indexPath.row];
            if (light.workstate==0) {
                [cell.iconBtn setImage:[UIImage imageNamed:@"dengon"] forState:UIControlStateNormal];
            }
            if (light.workstate==1) {
                [cell.iconBtn setImage:[UIImage imageNamed:@"dengoff"] forState:UIControlStateNormal];
            }
            cell.menuLabel.text=light.title;
        }
    }else{
        NSArray *templights=menuGroup.lights;
        
        if ([templights[indexPath.row]isKindOfClass:[Light class]]) {
            Light *light=templights[indexPath.row];
            if (light.workstate==0) {
                [cell.iconBtn setImage:[UIImage imageNamed:@"dengon"] forState:UIControlStateNormal];
            }
            if (light.workstate==1) {
                [cell.iconBtn setImage:[UIImage imageNamed:@"dengoff"] forState:UIControlStateNormal];
            }

            cell.menuLabel.text=light.title;
        }
    
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuGroup *menuGroup=self.menuGroups[indexPath.section];
    if(indexPath.section==0){
        if (![menuGroup.secondDatas[indexPath.row] isKindOfClass:[Light class]]) {
            [self showMessageTip:@"请点击路灯" detail:nil timeOut:0.3f];
        }else{
            if (self.navigationController!=nil&&self.navigationController.viewControllers!=nil&&self.navigationController.viewControllers.count>0) {
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[LightControlController class]]) {
                        LightControlController *lightController=(LightControlController *)viewController;
                        self.delegate=lightController;
                        [self.delegate reloadLightInfo:menuGroup.secondDatas[indexPath.row]];
                        [SLSlideMenu dismiss];
                        
                    }
                }
            }
        }
    }
    if (indexPath.section==1) {
        if (![menuGroup.lights[indexPath.row] isKindOfClass:[Light class]]) {
            [self showMessageTip:@"请点击路灯" detail:nil timeOut:0.3f];
        }else{
            if (self.navigationController!=nil&&self.navigationController.viewControllers!=nil&&self.navigationController.viewControllers.count>0) {
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[LightControlController class]]) {
                        LightControlController *lightController=(LightControlController *)viewController;
                        self.delegate=lightController;
                        [self.delegate reloadLightInfo:menuGroup.lights[indexPath.row]];
                        [SLSlideMenu dismiss];
                        
                    }
                }
            }
        }
    }

    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cellMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, slideMenuWidth, 44)];
    cellMenuView.alpha=1;
    //图标
    UIButton *iconView=[UIButton buttonWithType:UIButtonTypeCustom];
    [iconView setImage:[[UIImage imageNamed:@"shiqu"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
    iconView.frame=CGRectMake(10, (44-20)/2,15 ,15);
    [iconView setBackgroundColor:[UIColor whiteColor]];
    [cellMenuView addSubview:iconView];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width, 0, (slideMenuWidth-iconView.frame.size.width-15)*0.7, 44)];
    [button setTag:section+1];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickedMenuename) forControlEvents:UIControlEventTouchUpInside];
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (44-20)/2, button.frame.size.width, 20)];
    [tlabel setBackgroundColor:[UIColor clearColor]];
    [tlabel setFont:[UIFont systemFontOfSize:14]];
    [tlabel setTextAlignment:NSTextAlignmentCenter];
    if (self.menuGroups.count>0) {
        [tlabel setText:([self.menuGroups[section]name])];
    }
    
    MenuGroup *menuGroup=self.menuGroups[section];
    UIButton *jiantouBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jiantouBtn.frame=CGRectMake(button.frame.origin.x+button.frame.size.width, cellMenuView.frame.origin.y+12, 40,30);
    [jiantouBtn setTag:section+1];
    [jiantouBtn addTarget:self action:@selector(buttonPressMenuGroup:) forControlEvents:UIControlEventTouchUpInside];
    if (menuGroup.isClicked==NO) {
        [jiantouBtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
    }else{
        [jiantouBtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
    }
    
    [cellMenuView addSubview:jiantouBtn];

    //线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, cellMenuView.frame.size.height-1, cellMenuView.frame.size.width, 1)];
    [line setImage:[UIImage imageNamed:@"line_real"]];
    [button addSubview:line];
    [button addSubview:tlabel];
    [cellMenuView addSubview:button];
    
    return cellMenuView;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [self.menuGroups[section]name];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
#pragma mark 菜单各种点击事件
-(void)clickGetTopAreaData
{
    NSLog(@"前端点击");
}
//点击分组
-(void)clickedMenuename
{
    [self showMessageTip:@"请点击路灯" detail:nil timeOut:0.3f];
}
//更新分组数据
-(void)buttonPressMenuGroup:(UIButton *) sender
{
    //判断状态值
    if ([self.menuGroups[sender.tag-1] isKindOfClass:[MenuGroup class]]) {
        MenuGroup *menuGroup=self.menuGroups[sender.tag-1];
        if (menuGroup.isClicked==NO) {
            [menuGroup setIsClicked:YES];
        }else if (menuGroup.isClicked==YES){
            [menuGroup setIsClicked:NO];
        }
        NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:sender.tag-1];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        
    }

}
//点击省
-(void)clickGetCities:(CityBtn *)sender
{
    NSMutableArray *pathArr =[NSMutableArray array];
    MenuGroup *menuGroup=self.menuGroups[sender.indexPath.section];
    NSMutableArray *seconds=menuGroup.secondDatas;
    int indexCurrent=sender.indexPath.row;
    NSLog(@"当前菜单坐标:%d",indexCurrent);
    if ([menuGroup.secondDatas[sender.indexPath.row]isKindOfClass:[Privince class]]) {
        Privince *privince=menuGroup.secondDatas[sender.indexPath.row];
        if (privince.isClicked==NO) {
            //开启
            for (int i=0; i<privince.thirdDatas.count; i++) {
                [seconds insertObject:privince.thirdDatas[i] atIndex:(sender.indexPath.row+i+1)];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(sender.indexPath.row+i+1) inSection:sender.indexPath.section];
                [pathArr addObject:indexPath];
            }
            privince.isClicked=YES;
            [sender setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationRight];
            [self.tableView endUpdates];
        }else {
        //关闭
            privince.isClicked=NO;
            CityBtn *pbtn=(CityBtn *)sender;
            //开启
            for (int i=0; i<privince.thirdDatas.count; i++) {
                [seconds removeObjectAtIndex:(sender.indexPath.row+1)];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(sender.indexPath.row+i+1) inSection:pbtn.indexPath.section];
                [pathArr addObject:indexPath];
            }
            [sender setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }
        [self reloadJianTouBtnIndex:seconds];
    }
}

-(void)clickCityGetLights:(CityBtn *)sender
{

    NSMutableArray *pathArr =[NSMutableArray array];
    MenuGroup *menuGroup=self.menuGroups[sender.indexPath.section];
    NSMutableArray *seconds=menuGroup.secondDatas;
    int indexCurrent=sender.indexPath.row;
     NSLog(@"当前菜单坐标:%d",indexCurrent);
    @try {
        if ([menuGroup.secondDatas[sender.indexPath.row]isKindOfClass:[Cities class]]){
            Cities *city=seconds[sender.indexPath.row];
            if (city.isClicked==NO) {
                //开启
                city.isClicked=YES;
                for (int i=0; i<city.lights.count; i++) {
                    [seconds insertObject:city.lights[i] atIndex:(i+sender.indexPath.row+1)];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(sender.indexPath.row+i+1) inSection:0];
                    [pathArr addObject:indexPath];
                }
                [sender setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                
                
            }else if (city.isClicked==YES){
                //关闭
                city.isClicked=NO;
                for (int i=0; i<city.lights.count; i++) {
                    [seconds removeObjectAtIndex:(i+sender.indexPath.row+1)];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(sender.indexPath.row+i+1) inSection:0];
                    [pathArr addObject:indexPath];
                }
                [sender setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            
            [self reloadJianTouBtnIndex:seconds];
            
        }

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
   
    
}

-(void) reloadJianTouBtnIndex:(NSArray *)seconds
{
    for (int i=0; i<seconds.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
        SlideMenuCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        CityBtn *cityBtn=(CityBtn *)cell.jiantouBtn;
        int indexCurrent=cityBtn.indexPath.row;
        cityBtn.indexPath=indexPath;
    }
}

//点击获取区
-(void)clickGetAreas:(CityBtn *)sender
{
    CityBtn *cityBtn=(CityBtn *)sender;
    NSMutableArray *pathArr =[NSMutableArray array];
    MenuGroup *menuGroup=self.menuGroups[cityBtn.indexPath.section];
    NSMutableArray *seconds=menuGroup.secondDatas;
    if ([seconds[cityBtn.indexPath.row]isKindOfClass:[Cities class]]) {
        Cities *city=seconds[cityBtn.indexPath.row];
        if (city.areas!=nil&&city.areas.count>0) {
            if (city.isClicked==NO) {
                city.isClicked=YES;
                [cityBtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
                for (int i=0; i<city.areas.count; i++) {
                    [seconds insertObject:city.areas[i] atIndex:(cityBtn.indexPath.row+i+1)];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(cityBtn.indexPath.row+i+1) inSection:cityBtn.indexPath.section];
                    [pathArr addObject:indexPath];
                }
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }else{
                city.isClicked=NO;
                [cityBtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
                for (int i=0; i<city.areas.count; i++) {
                    [seconds removeObjectAtIndex:cityBtn.indexPath.row+1];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(cityBtn.indexPath.row+i+1) inSection:cityBtn.indexPath.section];
                    [pathArr addObject:indexPath];
                }
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            }
            [self reloadJianTouBtnIndex:seconds];
        }
        
    }
    
}
//点击区域获取路灯
-(void)clickAreaGetLights:(CityBtn *)sender
{

    CityBtn *cityBtn=(CityBtn *)sender;
    NSMutableArray *pathArr =[NSMutableArray array];
    MenuGroup *menuGroup=self.menuGroups[cityBtn.indexPath.section];
    NSMutableArray *seconds=menuGroup.secondDatas;
    if ([seconds[cityBtn.indexPath.row]isKindOfClass:[Area class]]) {
        Area *area=seconds[cityBtn.indexPath.row];
        if (area.isClicked==NO) {
            area.isClicked=YES;
            [cityBtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
            for (int i=0; i<area.lights.count; i++) {
                [seconds insertObject:area.lights[i] atIndex:(cityBtn.indexPath.row+i+1)];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(cityBtn.indexPath.row+i+1) inSection:cityBtn.indexPath.section];
                [pathArr addObject:indexPath];
            }
            [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
        }else{
            area.isClicked=NO;
            [cityBtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
            for (int i=0; i<area.lights.count; i++) {
                [seconds removeObjectAtIndex:cityBtn.indexPath.row+1];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(cityBtn.indexPath.row+i+1) inSection:cityBtn.indexPath.section];
                [pathArr addObject:indexPath];
            }
            [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
        }
    }

}
#pragma mark 懒加载
-(NSMutableArray *)qitas
{
    if (_qitas==nil) {
        _qitas=[NSMutableArray array];
    }
    return _qitas;
}
-(NSMutableArray *)menuGroups
{
    if (_menuGroups==nil) {
        _menuGroups=[NSMutableArray array];
    }
    return _menuGroups;
}
@end
