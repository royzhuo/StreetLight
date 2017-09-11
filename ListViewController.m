//
//  ListViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/3.
//  Copyright © 2017年 street. All rights reserved.
//

#import "ListViewController.h"
#import "LightManagerController.h"
#import "LightListCell.h"
#import "UITableView+MoreInfo.h"
#import "LightInfoUpdateController.h"
#import "LightDetailController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "LightDetailController.h"
#import "MJRefreshAutoNormalFooter.h"

#import "UrgenViewController.h"



static const CGFloat MJDuration = 2.0;

@interface ListViewController() < UITableViewDelegate,UITableViewDataSource,ListReloadDataDelegate,LightInfoDelegate>

@property(nonatomic,strong)LightListCell *lightListCell;
@property(nonatomic,strong) NSMutableArray *lights;
@property(nonatomic,strong) NSMutableArray *results;
@property(nonatomic,assign) int pageNo;//当前页
@property(nonatomic,strong) NSString *inccode;
@property(nonatomic,strong) NSString *regioncode;


@end

@implementation ListViewController

-(void)viewDidLoad
{

    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    self.view.backgroundColor=[UIColor yellowColor];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LightListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"lightCell"];
    self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.lightListCell = [self.tableView dequeueReusableCellWithIdentifier:@"lightCell"];
    
    self.lights=[NSMutableArray array];
    self.results=[NSMutableArray array];
    
    [self pullRefresh];
    [self footerRefresh];
    
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadView:) name:@"reGetToken" object:nil];
    
}

#pragma 通知
-(void)reloadView:(NSNotification *)notification
{
    [self loadNewData];
}


//下拉刷新
-(void)pullRefresh
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 设置文字
    [header setTitle:@"下拉来刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"准备刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"开始加载数据" forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
    // 设置颜色
    header.stateLabel.textColor = [UIColor blackColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor grayColor];
    
    // 马上进入刷新状态
    [header beginRefreshing];
    
    
    
    // 设置刷新控件
    self.tableView.mj_header = header;
}

-(void)loadNewData
{
    
    self.pageNo=1;
    [self loadData:self.pageNo withRereshMethodType:RRefreshMethodTypePull];
}

//上拉刷新
-(void)footerRefresh
{
    
    // 添加默认的上拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // 设置文字
    [footer setTitle:@"点击或者上拉拉刷新数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"加载更多 ..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置颜色
    footer.stateLabel.textColor = [UIColor grayColor];
    
    // 设置footer
    self.tableView.mj_footer = footer;
    
}

-(void)loadMoreData
{
    if ((self.latitude!=0)&&(self.longitude!=0)&&(self.regioncode==nil)&&(self.inccode==nil)) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
    }else{
        if (self.pageNo<1) {
            self.pageNo=1;
        }
        [self loadData:self.pageNo withRereshMethodType:RefreshMethodTypeDrap];
    }
    
}


//网络请求

-(void)loadData:(int )pageNo withRereshMethodType:(RefreshMethodType) refreshMethodType
{

    NSString *params=@"";
    if(self.navigationController!=nil){
        if (self.navigationController.viewControllers!=nil &&self.navigationController.viewControllers.count) {
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[LightManagerController class]]) {
                    LightManagerController *lightManager=(LightManagerController *)viewController;
                    MapViewController *mapViewController=lightManager.mapViewController;
                    if (mapViewController!=nil) {
                        self.longitude=mapViewController.longitude;
                        self.latitude=mapViewController.latitude;
                    }
                    
                }
            }
        }
    }
    if ((self.latitude!=0)&&(self.longitude!=0)&&(self.regioncode==nil)&&(self.inccode==nil)) {
        params=[NSString stringWithFormat:@"?latitude=%f&longitude=%f&toKen=%@",self.latitude,self.longitude,[User sharedInstance].token];
        [self.lights removeAllObjects];
        [self.results removeAllObjects];
        
    }else{
        
        if(refreshMethodType==RRefreshMethodTypePull){
            params=[NSString stringWithFormat:@"?pageNo=%@&pageSize=%@&inccode=%@&regioncode=%@&toKen=%@",[NSString stringWithFormat:@"%d",pageNo],[NSString stringWithFormat:@"%d",pageSize],self.inccode,self.regioncode,[User sharedInstance].token];
        }else{
             params=[NSString stringWithFormat:@"?pageNo=%@&pageSize=%@&inccode=%@&regioncode=%@&toKen=%@",[NSString stringWithFormat:@"%d",pageNo+1],[NSString stringWithFormat:@"%d",pageSize],self.inccode,self.regioncode,[User sharedInstance].token];
        }
        
    }
    
        //加载数据
    [self showLoaddingTip:@"加载路灯信息....."];
        [[HttpTool sharedInstance]Get:regionLamp params:params success:^(id responseObj) {
            if (responseObj) {
                BOOL isSuccess=[[responseObj objectForKey:@"success"]boolValue];
                if (isSuccess) {
                    if (refreshMethodType==RRefreshMethodTypePull) {
                        //下拉刷新
                        [self.lights removeAllObjects];
                        [self.results removeAllObjects];
                        // 拿到当前的下拉刷新控件，结束刷新状态
                        [self.tableView.mj_header endRefreshing];
                    }
                    NSArray *result=[responseObj objectForKey:@"result"];
                    
                    if (result.count>0) {
                        [self dissmissTips];
                        self.pageNo+=1;
                        for (NSDictionary *dic in result) {
                            [self.results addObject:dic];
                            Light *light=[[Light alloc]initWithTitleIcon:@"gz" withTile:[dic valueForKey:@"lampname"] withLightCode:[dic valueForKey:@"lampnum"] withLightAddress:[dic valueForKey:@"lampaddress"]];
                            [self.lights addObject:light];
                        }
                        // 刷新表格
                        [self.tableView reloadData];
                        if (refreshMethodType==RefreshMethodTypeDrap) {
                            //下拉刷新
                            [self.tableView.mj_footer endRefreshing];
                        }
                    }else if(result.count<1&&(refreshMethodType==RefreshMethodTypeDrap)){
                        [self.tableView.mj_footer endRefreshing];
                        if (self.pageNo<2) {
                            self.pageNo=1;
                        }
                        [self dissmissTips];
                    }else{
                        [self dissmissTips];
                        [self.tableView reloadData];
                    }
                }else{
                    [self dissmissTips];
                    [self showFailureTip:@"加载失败" detail:nil timeOut:0.3f];
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                    int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                    if (tokenCode!=0) {
                        [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                    }
                }
            }
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"%@",error);
                [self dissmissTips];
                [self showFailureTip:@"网络问题,请检查" detail:nil timeOut:0.3f];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
        }];

}

#pragma mark 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView tableViewDisplayWitMsg:@"没有路灯数据信息" ifNecessaryForRowCount:self.lights.count];
    return self.lights.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

//    LightListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"lightCell"];
    LightListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"lightCell" forIndexPath:indexPath];
    
    //[self configureCell:cell atIndexPath:indexPath];
    cell.light=self.lights[indexPath.section];
    cell.moreBtn.tag=indexPath.section;
    [cell.moreBtn addTarget:self action:@selector(clickMore:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag=indexPath.section;
    [cell.editBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
return [tableView fd_heightForCellWithIdentifier:@"lightCell" configuration:^(id cell) {
    [self configureCell:cell atIndexPath:indexPath];
}];
}


//侧滑菜单协议
-(void)reloadListDataByInccode:(NSString *)inccode withRegioncode:(NSString *)regioncode
{
    NSLog(@"企业编码:%@  区域编码:%@",inccode,regioncode);
    self.inccode=inccode;
    self.regioncode=regioncode;
    NSString *params=[NSString stringWithFormat:@"?pageNo=%@&pageSize=%@&inccode=%@&regioncode=%@&toKen=%@",@"1",[NSString stringWithFormat:@"%d",pageSize],inccode,regioncode,[User sharedInstance].token];
    
    [self loadData:1 withRereshMethodType:RRefreshMethodTypePull];
    
}




#pragma mark 动态计算cell高度 方法
- (void)configureCell:(LightListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES; // Enable to use "-sizeThatFits:"
    cell.light = self.lights[indexPath.section];
}

#pragma mark 编辑 更多点击事件
//详情
-(void)clickMore:(UIButton *) sender
{
    LightDetailController *lightDetailController=[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"lightDetail"];
     NSDictionary *result=self.results[sender.tag];
    lightDetailController.lightResult=result;
//    [self presentViewController:lightDetailController animated:YES completion:nil];
    [lightDetailController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:lightDetailController animated:YES];
   
}
//编辑
-(void)clickEdit:(UIButton *)sender
{
   
    //编辑路灯信息
    LightInfoUpdateController *lightUpdateController=[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"lightUpdate"];
    lightUpdateController.modalPresentationStyle=UIModalPresentationFormSheet;
    lightUpdateController.lightResult=self.results[sender.tag];
    lightUpdateController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:lightUpdateController animated:YES];
}

#pragma mark 路灯更新是否成功
-(void)lightInfoUpdateIsSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        [self loadNewData];
    }
}
@end
