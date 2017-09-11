    //
//  LightManagerControllerViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightManagerController.h"

#import "Privince.h"
#import "Cities.h"
#import "Area.h"

#import "SLSlideMenu.h"
#import "SlideMenuCell.h"
#import "CityBtn.h"


//#define LeftWidth ([[UIScreen mainScreen] bounds].size.width/2.0+50)
//
//#define RightWidth ([[UIScreen mainScreen] bounds].size.width/2.0+50)
@interface LightManagerController ()<SLSlideMenuProtocol,UITableViewDelegate,UITableViewDataSource>

{

    float slideMenuWidth;
    float slideMenuoffset;

}
@property(nonatomic,strong) UISegmentedControl *segmentedControl;
@property(nonatomic,strong) UIView *toolTopView;
@property(nonatomic,strong)UIButton *mapBtn;
@property(nonatomic,strong)UIButton *listBtn;
@property(nonatomic,strong)UIView *line;



@property(nonatomic,strong)UIBarButtonItem *menues;

@property(nonatomic,strong) UITableView *menueTableView;
@property(nonatomic,strong) UILabel *diQuTopLabel;

@property(nonatomic,strong) UILabel *weiFenZhuLabel;

@property(nonatomic,strong) NSMutableArray *topAddress;//地域最顶级
@property(nonatomic,strong) NSMutableArray *privinces;//所有省
@property(nonatomic,strong) NSMutableArray *privincesState;//存放是否有点击的状态
@property(nonatomic,strong) NSMutableArray *allCities;//所有城市
@property(nonatomic,strong) NSMutableArray *allArea;//所有区域

@property(nonatomic,assign) BOOL isClicked;//判断菜单是否有点击过了

@end

@implementation LightManagerController

#pragma mark 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.tabBarController.tabBar.translucent=NO;
    
    //顶部工具视图
    [self initTopToolView];
    //添加地图控制器
    self.mapViewController=[[MapViewController alloc]init];
    [self addChildViewController:self.mapViewController];
    self.mapViewController.view.frame=CGRectMake(self.toolTopView.frame.origin.x, self.toolTopView.frame.origin.y+self.toolTopView.frame.size.height, self.toolTopView.frame.size.width, self.view.frame.size.height-self.toolTopView.frame.size.height) ;
    [self.view addSubview:self.mapViewController.view];
    
    int dingweiBtnWidth=ScreenWidth/10;
    int dingweiBtnHeight=ScreenWidth/10;
    self.mapViewController.dingweiBtn.frame=CGRectMake(dingweiBtnWidth, self.mapViewController.view.bounds.size.height-dingweiBtnWidth*6, dingweiBtnWidth, dingweiBtnHeight);
    
    //添加列表控制器
    self.listViewController=[[ListViewController alloc]init];
    [self.listViewController.view setFrame:self.mapViewController.view.frame];
    
    [self addChildViewController:self.listViewController];
    //地域容器初始化
    self.topAddress=[NSMutableArray array];
    self.privinces=[NSMutableArray array];
    self.allCities=[NSMutableArray array];
    self.allArea=[NSMutableArray array];
    
    
    self.listViewController.tabBarController.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.isClicked=NO;
    

    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
self.navigationItem.title=@"路灯管理";
   

}

//加载顶部工具视图
-(void)initTopToolView
{
    //添加顶部视图
    self.toolTopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.toolTopView];
    //地图按钮
    self.mapBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.mapBtn.frame=CGRectMake(0, 0, ScreenWidth/2, _toolTopView.frame.size.height-1);
    [self.mapBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.mapBtn setTitle:@"地图展示" forState:UIControlStateNormal];
    [self.mapBtn setTitleColor:RGB(0, 205, 102) forState:UIControlStateSelected];
    [self.mapBtn setTitle:@"地图展示" forState:UIControlStateNormal];
    self.mapBtn.selected=YES;
    [self.mapBtn addTarget:self action:@selector(clistMapView:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolTopView addSubview:self.mapBtn];
    
    
    //列表显示按钮
    self.listBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.listBtn.frame=CGRectMake(self.mapBtn.frame.origin.x+self.mapBtn.frame.size.width, 0, ScreenWidth/2,_toolTopView.frame.size.height-1 );
    [self.listBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.listBtn setTitle:@"列表展示" forState:UIControlStateNormal];
    [self.listBtn setTitleColor:RGB(0, 205, 102) forState:UIControlStateSelected];
    [self.listBtn setTitle:@"列表展示" forState:UIControlStateSelected];
    [self.toolTopView addSubview:self.listBtn];
    [self.listBtn addTarget:self action:@selector(initListView:) forControlEvents:UIControlEventTouchUpInside];
    
    //线
    self.line=[[UIView alloc]init];
    self.line.frame=CGRectMake(self.mapBtn.frame.origin.x, self.toolTopView.bounds.size.height-1, self.mapBtn.bounds.size.width, 1);
    self.line.backgroundColor=RGB(0, 205, 102);
    [self.toolTopView addSubview:self.line];

}

//地图视图
-(void)getMapView
{

}


#pragma mark 点击事件
//点击地图视图
-(void)clistMapView:(id)sender
{
    UIButton *mapBtn=(UIButton *)sender;
    if (!mapBtn.isSelected) {
        
        self.line.frame=CGRectMake(self.mapBtn.frame.origin.x, self.toolTopView.bounds.size.height-1, self.mapBtn.bounds.size.width, 1);
        self.mapBtn.selected=YES;
        self.listBtn.selected=NO;
        //切换视图
//       NSArray<UIViewController *> *vieconts= [self childViewControllers];
//        [self transitionFromViewController:self.listViewController toViewController:self.mapViewController duration:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
//            self.mapViewController.view.frame=self.listViewController.view.frame;
//            [self.listViewController.view removeFromSuperview];
//            //[self addChildViewController:self.mapViewController];
//            [self.navigationItem setRightBarButtonItem:nil];
//        } completion:^(BOOL finished) {
//            if (finished) {
//                
//                [self.mapViewController didMoveToParentViewController:self];
//            }
//        }];
    }
    [self transitionFromViewController:self.listViewController toViewController:self.mapViewController duration:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
         [self.navigationItem setRightBarButtonItem:nil];
    } completion:^(BOOL finished) {
        if (finished) {
            [self.listViewController.view removeFromSuperview];
            [self.view addSubview:self.mapViewController.view];
        }
    }];

     NSLog(@"切换地图视图");
    
}

//列表视图
-(void)initListView:(id)sender
{
    UIButton *listBtn=(UIButton *)sender;
    if (!listBtn.isSelected) {
        self.line.frame=CGRectMake(self.listBtn.frame.origin.x, self.toolTopView.bounds.size.height-1, self.listBtn.bounds.size.width, 1);
        
        self.mapBtn.selected=NO;
        self.listBtn.selected=YES;
        
        //切换视图
        [self transitionFromViewController:self.mapViewController toViewController:self.listViewController duration:0.3f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.menues=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStyleDone target:self action:@selector(clickMenu)];
                        [self.navigationItem setRightBarButtonItem:self.menues];
            self.listViewController.view.frame=CGRectMake(0,self.toolTopView.frame.origin.y+self.toolTopView.frame.size.height, self.view.frame.size.width,( self.view.frame.size.height-self.toolTopView.frame.size.height));
            self.listViewController.tableView.frame=CGRectMake(0,0, self.view.frame.size.width,self.listViewController.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [self.mapViewController.view removeFromSuperview];
                if (self.mapViewController.longitude!=0) {
                    
                    self.listViewController.longitude=self.mapViewController.longitude;
                }
                if (self.mapViewController.latitude!=0) {
                    self.listViewController.latitude=self.mapViewController.latitude;
                }

                [self.view addSubview:self.listViewController.view];
                
            }
        }];


    }

    NSLog(@"切换列表视图");
}

//菜单
-(void)clickMenu
{
    //侧滑菜单
    self.menueTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.menueTableView.delegate=self;
    self.menueTableView.dataSource=self;
    //注册侧滑页面cellid
    [self.menueTableView registerNib:[UINib nibWithNibName:@"SlideMenuCell" bundle:nil] forCellReuseIdentifier:@"SlideMenuCellId"];
    
    slideMenuWidth=screenW*0.8;
    slideMenuoffset=screenW-slideMenuWidth;
    CGRect frame=self.view.frame;
    [SLSlideMenu slideMenuWithFrame:CGRectMake(0, 0, slideMenuWidth, screenH)
                           delegate:self
                          direction:SLSlideMenuDirectionRight
                        slideOffset:slideMenuoffset
                allowSwipeCloseMenu:YES
                           aboveNav:YES
                         identifier:@"right"
                             object:self.menues];
    
}



#pragma mark 侧滑菜单协议
-(void)slideMenu:(SLSlideMenu *)slideMenu prepareSubviewsForMenuView:(UIView *)menuView
{
    CGRect menuvf=menuView.frame;
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, menuView.frame.size.width, 64)];
    titleView.backgroundColor=[UIColor grayColor];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:titleView.frame];
    titleLabel.text=@"路灯选择";
    titleLabel.font=[UIFont boldSystemFontOfSize:16];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [titleView addSubview:titleLabel];
    [menuView addSubview:titleView];
    
    //区域顶端
    UIView *secondView=[self getTopDiquview];
    [menuView addSubview:secondView];
    
    //表格
    self.menueTableView.frame=CGRectMake(0, titleView.frame.origin.y+titleView.frame.size.height+44, menuView.frame.size.width, menuView.frame.size.height-secondView.frame.size.height-secondView.frame.origin.y);
    [menuView addSubview:self.menueTableView];
    CGRect fame2=self.menueTableView.frame;
    
    //未分组视图
    UIView *weiFenZuView=[self getWeiFenZuView];
    CGRect frame1=weiFenZuView.frame;
    //[menuView addSubview:weiFenZuView];
    self.menueTableView.tableFooterView=weiFenZuView;
    
    //如果菜单是第一次点击
    if (!self.isClicked) {
        //路灯区域信息加载
        NSString *params=[NSString stringWithFormat:@"?isViewLight=%d&toKen=%@&inccode=%@",true,[User sharedInstance].token,[User sharedInstance].inccode];
        [self showLoaddingTip:@"加载区域信息"];
        [[HttpTool sharedInstance]Get:getRegion params:params success:^(id responseObj) {
            if (responseObj) {
                //异步处理数据
                    Boolean isSuccess=[[responseObj valueForKey:@"success"]boolValue];
                    if (isSuccess) {
                        NSArray *results=[responseObj valueForKey:@"result"];
                        for(int i=0;i<results.count;i++){
                            NSDictionary *result=results[i];
                            NSString *name=[result valueForKey:@"name"];
                            NSString *selfId=[result valueForKey:@"id"];
                            NSString *pId=[result valueForKey:@"pId"];
                            int *isRegion=[[result valueForKey:@"isRegion"]intValue];
                            int *level=[[result valueForKey:@"level"]integerValue];
                            // NSLog(@"名称:%@",name);
                            if([pId isEqualToString:@""]){
                                [self.topAddress addObject:result];
                            }else {
                                //得到省
                                if ([name containsString:@"省"]) {
                                    Privince *privince=[[Privince alloc]initPrivinceWithId:selfId withPrivinceName:name withRegion:isRegion withLevel:level withParentId:pId];
                                    privince.isClicked=NO;
                                    [self.privinces addObject:privince];
                                }else if([name containsString:@"市"]){
                                    //得到市
                                    Cities *city=[[Cities alloc]initCityWithId: selfId withCityName:name withRegion:isRegion withLevel:level withParentId:pId];
                                    city.isClicked=NO;
                                    [self.allCities addObject:city];
                                }else{
                                    Area *area=[[Area alloc]initAreaWithId:selfId withAreaName:name withRegion:isRegion withLevel:level withParentId:pId];
                                    [self.allArea addObject:area];
                                }
                            }
                        }
                        NSMutableArray *tempCities=[NSMutableArray array];
                        for (int i=0;i< self.privinces.count;i++) {
                            if ([self.privinces[i] isKindOfClass:[Privince class]]) {
                                Privince *privince=self.privinces[i];
                                for (Cities *city in self.allCities) {
                                    if ([city.parentId isEqualToString:privince.selfId]) {
                                        if (privince.citys==nil) {
                                            privince.citys=[NSMutableArray array];
                                        }
                                        if (![privince.citys containsObject:city]) {
                                            [privince.citys addObject:city];
                                        }
                                    }
                                    if ([city.name containsString:@"厦门市"]) {
                                        if (![tempCities containsObject:city]) {
                                            [tempCities addObject:city];
                                        }
                                        
                                    }
                                }
                            }

                        }
                        
                        for (int i=0; i<self.privinces.count; i++) {
                            if ([self.privinces[i] isKindOfClass:[Privince class]]) {
                                Privince *privince=self.privinces[i];
                                if (privince.citys!=nil&&privince.citys.count>0) {
                                    for (Cities *city in privince.citys) {
                                        for (Area *area in self.allArea) {
                                            if ([area.parentId isEqualToString:city.selfId]) {
                                                if (city.areas==nil) {
                                                    city.areas=[NSMutableArray array];
                                                }
                                                if (![city.areas containsObject:area]) {
                                                    [city.areas addObject:area];
                                                }
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        [self.privinces addObjectsFromArray:tempCities];
                        
                        
                            //刷新数据
                            [self dissmissTips];
                            [self showSuccessTip:@"加载完成" timeOut:0.3f];
                            [self.menueTableView reloadData];
                            if (self.topAddress!=nil) {
                                for (NSDictionary *dic in self.topAddress) {
                                    NSString *addressName=[dic valueForKey:@"name"];
                                    if ([addressName containsString:@"顶级"]) {
                                        self.diQuTopLabel.text=addressName;
                                    }
                                    if ([addressName containsString:@"未分组区域"]) {
                                        self.weiFenZhuLabel.text=addressName;
                                    }
                                }
                            }
                            self.isClicked=YES;
                        
                        
                    }else{
                        [self dissmissTips];
                        [self showFailureTip:@"加载失败" detail:nil timeOut:0.3f];
                        [SLSlideMenu dismiss];
                        int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                        if (tokenCode!=0) {
                            [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                        }
                    }
                
            }
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                [self showFailureTip:@"网络异常，加载失败" detail:nil timeOut:0.3f];
            }
        }];
    }

    
    
    
}

//加载路灯顶级区域视图
-(UIView *)getTopDiquview
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
    
    return cellMenuView;
}

//加载未分组视图
-(UIView *) getWeiFenZuView
{
//    UIView *cellMenuView=[[UIView alloc]initWithFrame:CGRectMake(0,self.menueTableView.frame.origin.y+self.menueTableView.frame.size.height, self.view.frame.size.width, 44)];
    UIView *cellMenuView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 44)];
    //图标
    UIButton *iconView=[UIButton buttonWithType:UIButtonTypeCustom];
    [iconView setImage:[UIImage imageNamed:@"shiqu"] forState:UIControlStateNormal];
    iconView.frame=CGRectMake(0, 10,15 ,15);
    [iconView setBackgroundColor:[UIColor whiteColor]];
    [cellMenuView addSubview:iconView];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width, 0, (self.view.frame.size.width-iconView.frame.origin.x-iconView.frame.size.width-15)*0.7, 44)];
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
    
    return cellMenuView;

}

#pragma mark 侧滑数据菜单
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.privinces.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Privince *privince=self.privinces[section];
    if (privince.isClicked==YES) {
        NSArray *cities=[(self.privinces[section]) citys];
        return cities.count;
    }else{
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SlideMenuCell *slideMenuCell=[tableView dequeueReusableCellWithIdentifier:@"SlideMenuCellId"];
    
    
    
    
    NSMutableArray *cities=[(self.privinces[indexPath.section]) citys];
    CityBtn *cityBtn=(CityBtn *)slideMenuCell.jiantouBtn;
    cityBtn.indexPath=indexPath;
    
    //判断该对象是不是城市
    if ([cities[indexPath.row] isKindOfClass:[Cities class]]) {
        Cities *city=cities[indexPath.row] ;
        slideMenuCell.menuLabel.text=city.name;
        if (city.areas!=nil&&city.areas.count>0) {
            cityBtn.hidden=NO;
            [cityBtn addTarget:self action:@selector(clickCityBtn:) forControlEvents:UIControlEventTouchUpInside];
            if (city.isClicked==YES) {
                [cityBtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
            }else{
                [cityBtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
                
            }
            
            
        }
    }else {
        Area *area=cities[indexPath.row];
        slideMenuCell.menuLabel.text=area.name;
        cityBtn.hidden=YES;
    }
    
//    //判断该对象是不是城市
//    if ([cities[indexPath.row] isKindOfClass:[Cities class]]) {
//        Cities *city=cities[indexPath.row] ;
//        [resultBtn setTitle:city.name forState:UIControlStateNormal];
//        if (city.areas!=nil&&city.areas.count>0) {
//             CGRect iconframe=resultBtn.frame;
////            jiantou.frame=CGRectMake(iconframe.origin.x, iconframe.origin.y, iconframe.size.width, iconframe.size.height);
//           // jiantou.image=[UIImage imageNamed:@"left_jiantou"];
//            [resultBtn addTarget:self action:@selector(clickCityBtn:) forControlEvents:UIControlEventTouchUpInside];
//            
//        }
//    }else {
//        UIButton *dingweiIcon=[slideMenuCell viewWithTag:1200];
//        CGRect jiantouFrame=dingweiIcon.frame;
//        dingweiIcon.frame=CGRectMake(jiantouFrame.origin.x+40, jiantouFrame.origin.y, jiantouFrame.size.width, jiantouFrame.size.height);
//        CGRect dingweiFrame=dingweiIcon.frame;
//        Area *area=cities[indexPath.row];
//        [resultBtn setTitle:area.name forState:UIControlStateNormal];
//    }
    
    return slideMenuCell;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return self.privinces[section];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"第%ld组%ld行",(long)indexPath.section,(long)indexPath.row);
     NSMutableArray *pathArr =[NSMutableArray array];
     NSMutableArray *cities=[self.privinces[indexPath.section] citys];
    SlideMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SlideMenuCellId" forIndexPath:indexPath];
    //判断点击的是否是城市
    if ([cities[indexPath.row] isKindOfClass:[Cities class]]) {
        Cities *city=([self.privinces[indexPath.section] citys])[indexPath.row] ;
        self.listDelegate=self.listViewController;
        [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:city.selfId];
        [SLSlideMenu dismiss];
        
    }else{
    
        Area *area=cities[indexPath.row];
        self.listDelegate=self.listViewController;
        [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:area.selfId];
        [SLSlideMenu dismiss];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *cellMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, slideMenuWidth, 44)];
    //图标
    UIButton *iconView=[UIButton buttonWithType:UIButtonTypeCustom];
    [iconView setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    iconView.frame=CGRectMake(10, 10,15 ,15);
    [iconView setBackgroundColor:[UIColor whiteColor]];
    [cellMenuView addSubview:iconView];
    //按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(iconView.frame.origin.x+iconView.frame.size.width, 0, (slideMenuWidth-iconView.frame.size.width-15)*0.7, 44)];
    [button setTag:section+1];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressGetPrinvice:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *tlabel = [[UILabel alloc]initWithFrame:CGRectMake(45, (44-20)/2, button.frame.size.width, 20)];
    [tlabel setBackgroundColor:[UIColor clearColor]];
    [tlabel setFont:[UIFont systemFontOfSize:14]];
    if ([self.privinces[section] isKindOfClass:[Cities class]]) {
        [tlabel setText:([self.privinces[section] name])];
    }else{
        Privince *privince=self.privinces[section];
        [tlabel setText:privince.name];
        //剪头
        if (privince.citys!=nil&&privince.citys.count>0) {
            UIButton *jiantouBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            jiantouBtn.frame=CGRectMake(button.frame.origin.x+button.frame.size.width, cellMenuView.frame.origin.y+12, cellMenuView.frame.size.height/2, cellMenuView.frame.size.height/2);
            [jiantouBtn setTag:section+1];
            [jiantouBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
            if (privince.isClicked==NO) {
                [jiantouBtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
            }else{
                [jiantouBtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
            }
            
            [cellMenuView addSubview:jiantouBtn];
        }else{
            UIButton *seachBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            seachBtn.frame=CGRectMake(button.frame.origin.x+button.frame.size.width, cellMenuView.frame.origin.y, 14, cellMenuView.frame.size.height);
            [cellMenuView addSubview:seachBtn];
        }
    }
    //线
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, cellMenuView.frame.size.height-1, cellMenuView.frame.size.width, 1)];
    [line setImage:[UIImage imageNamed:@"line_real"]];
    [button addSubview:line];
    [button addSubview:tlabel];
    [cellMenuView addSubview:button];
    
    
    if (self.topAddress!=nil) {
        for (NSDictionary *dic in self.topAddress) {
            NSString *addressName=[dic valueForKey:@"name"];
            if ([addressName containsString:@"顶级"]) {
                self.diQuTopLabel.text=addressName;
            }
            if ([addressName containsString:@"未分组区域"]) {
                self.weiFenZhuLabel.text=addressName;
            }
        }
    }
    return cellMenuView;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


#pragma mark 点击获取省 市信息
- (void)buttonPress:(UIButton *)sender//headButton点击
{
    //判断状态值
    if ([self.privinces[sender.tag-1] isKindOfClass:[Privince class]]) {
        Privince *privince=self.privinces[sender.tag-1];
        if (privince.citys!=nil&&privince.citys.count>0) {
            if (privince.isClicked==NO) {
                [(self.privinces[sender.tag-1]) setIsClicked:YES];
            }else{
                [(self.privinces[sender.tag-1]) setIsClicked:NO];
            }
            
            [self.menueTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag-1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            self.listDelegate=self.listViewController;
            [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:privince.selfId];
            [SLSlideMenu dismiss];
        }
    }
}
-(void) buttonPressGetPrinvice:(UIButton *)sender
{

    //判断状态值
    if ([self.privinces[sender.tag-1] isKindOfClass:[Privince class]]) {
        Privince *privince=self.privinces[sender.tag-1];
        self.listDelegate=self.listViewController;
        [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:privince.selfId];
        [SLSlideMenu dismiss];

        
    }else{
        Cities *city=self.privinces[sender.tag-1];
        self.listDelegate=self.listViewController;
        [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:city.selfId];
        [SLSlideMenu dismiss];

    }
}
//点击获取未分组数据
-(void)clickGetWeiFenZuData
{
    
    if (self.topAddress!=nil&&self.topAddress.count>0) {
        for (NSDictionary *dic in self.topAddress) {
            NSString *addressName=[dic valueForKey:@"name"];
            if ([addressName containsString:@"未分组区域"]) {
                NSString *regionCode=[dic valueForKey:@"id"];
                self.listDelegate=self.listViewController;
                [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:regionCode];
                [SLSlideMenu dismiss];
                
            }
        }
    }

}

//点击获取顶部数据
-(void)clickGetTopAreaData
{
    if (self.topAddress!=nil&&self.topAddress.count>0) {
        for (NSDictionary *dic in self.topAddress) {
            NSString *addressName=[dic valueForKey:@"name"];
            if ([addressName containsString:@"顶级"]) {
                NSString *regionCode=[dic valueForKey:@"id"];
                self.listDelegate=self.listViewController;
                [self.listDelegate reloadListDataByInccode:[User sharedInstance].inccode withRegioncode:regionCode];
                [SLSlideMenu dismiss];
            }
        }
    }
   }

//点击城市按钮
-(void)clickCityBtn:(UIButton *)sender
{
    CityBtn *cityBtn=(CityBtn *)sender;
    
    NSMutableArray *pathArr =[NSMutableArray array];
    NSMutableArray *cities=[self.privinces[cityBtn.indexPath.section] citys];
    
    int indexCurrent=cityBtn.indexPath.row;
    NSLog(@"当前菜单坐标:%d",indexCurrent);
    //判断点击的是否是城市
    if ([cities[cityBtn.indexPath.row] isKindOfClass:[Cities class]]) {
        Cities *city=([self.privinces[cityBtn.indexPath.section] citys])[cityBtn.indexPath.row] ;
        if (city.isClicked==YES) {
            //关闭
            for (int i=0; i<city.areas.count; i++) {
                NSIndexPath *path =[NSIndexPath indexPathForRow:cityBtn.indexPath.row+i+1 inSection:cityBtn.indexPath.section];
                [pathArr addObject:path];
                [ cities removeObjectAtIndex:cityBtn.indexPath.row+1];
            }
            [self.menueTableView beginUpdates];
            
            //删除IndexPaths 数组
            [self.menueTableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationBottom];
            [self.menueTableView endUpdates];
            city.isClicked=NO;
            [cityBtn setImage:[UIImage imageNamed:@"left_jiantou"] forState:UIControlStateNormal];
            [self reloadJianTouBtnIndex:cities with:cityBtn.indexPath.section];
            
        }else if(city.isClicked==NO){
            //开启
            for (int i=0; i<city.areas.count; i++) {
                NSIndexPath *path =[NSIndexPath indexPathForRow:cityBtn.indexPath.row+i+1 inSection:cityBtn.indexPath.section];
                [pathArr addObject:path];
                [ cities insertObject:city.areas[i] atIndex:cityBtn.indexPath.row+i+1];
            }
            [self.menueTableView beginUpdates];
            //增加IndexPaths 数组
            [self.menueTableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationBottom];
            city.isClicked=YES;
            [self.menueTableView endUpdates];
            [cityBtn setImage:[UIImage imageNamed:@"down_jiantou"] forState:UIControlStateNormal];
            [self reloadJianTouBtnIndex:cities with:cityBtn.indexPath.section];
        }
    }
}
-(void) reloadJianTouBtnIndex:(NSArray *)seconds with:(NSInteger *)setion
{
    for (int i=0; i<seconds.count; i++) {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:setion];
        SlideMenuCell *cell=[self.menueTableView cellForRowAtIndexPath:indexPath];
        CityBtn *cityBtn=(CityBtn *)cell.jiantouBtn;
        cityBtn.indexPath=indexPath;
    }
}
@end
