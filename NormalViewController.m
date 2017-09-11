//
//  NormalViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import "NormalViewController.h"
#import "Warn.h"
#import "WarnCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"
#import "UrgenViewController.h"

@interface NormalViewController ()
@property(nonatomic,strong)NSMutableArray *warns;
@property(nonatomic,assign)int pageNo;

@end

@implementation NormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableviewAndData];
    //[self pullRefresh];
    [self footerRefresh];
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(notifiUpdateData:) name:@"updateWarnData" object:nil];
   // [notificationCenter addObserver:self selector:@selector(reloadView:) name:@"reGetToken" object:nil];
}

#pragma mark 通知中心
-(void) notifiUpdateData:(NSNotification *)notification
{
    NSMutableDictionary *notifyUserInfo=notification.userInfo;
    int notifyPageNo=[[notifyUserInfo valueForKey:@"pageNo"]integerValue];
    if (notifyPageNo==3) {
        if ((self.warns!=nil)&&(self.warns.count==0)) {
            [self pullRefresh];
        }
    }
}
-(void)reloadView:(NSNotification *)notification
{
    [self loadNewData];
}
-(void)dealloc
{
    //删除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma 上下拉刷新 网络请求

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
    if (self.pageNo<1) {
        self.pageNo=1;
    }else{
        self.pageNo+=1;
    }
    
    [self loadData:self.pageNo withRereshMethodType:RefreshMethodTypeDrap];
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
    header.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
    
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

//网络请求
-(void)loadData:(int )pageNo withRereshMethodType:(RefreshMethodType) refreshMethodType
{
    
    NSString *pageNoStr=[ NSString stringWithFormat:@"%d",pageNo ];
    NSString *params=[NSString stringWithFormat:@"?pageNo=%@&pageSize=%@&inccode=%@&toKen=%@",pageNoStr,[ NSString stringWithFormat:@"%d",pageSize ],[User sharedInstance].inccode,[User sharedInstance].token];
    [[HttpTool sharedInstance]Get:lampAlarm params:params success:^(id responseObj) {
        if (responseObj) {
            NSLog(@"success;%@",responseObj);
            BOOL isSuccess=[[responseObj valueForKey:@"success"]boolValue];
            if (isSuccess) {
                if (refreshMethodType!=nil&&refreshMethodType==RRefreshMethodTypePull) {
                    //下拉刷新
                    [self.warns removeAllObjects];
                    // 拿到当前的上拉刷新控件，结束刷新状态
                    [self.tableView.mj_header endRefreshing];
                }
                NSArray *results=[responseObj valueForKey:@"result"];
                for (NSDictionary *dic in results) {
                    
                    //判断是不是紧急警告
                    if ([[dic valueForKey:@"alarmtype"]intValue]==0) {
                        Warn *warn=[[Warn alloc]initWithAlarmtime:[[dic valueForKey:@"alarmtime"]longValue] withAlarmcontent:[dic valueForKey:@"alarmcontent"] withAlarmtype:[[dic valueForKey:@"alarmtype"]intValue] withWarnId:[dic valueForKey:@"id"] withInccode:[dic valueForKey:@"inccode"] withIshandle:[[dic valueForKey:@"ishandle"]intValue] withIsMsg:[[dic valueForKey:@"ismsg"]intValue] withName:[dic valueForKey:@"lampname"] withLamptype:[[dic valueForKey:@"lamptype"]intValue] withMsgTime:[[dic valueForKey:@"msgtime"]longValue] withRegionname:[dic valueForKey:@"regionname"]];
                        [self.warns addObject:warn];
                    }
                    
                }
                NSLog(@"warns:%@",self.warns);
                [self.tableView reloadData];
                if (refreshMethodType==RefreshMethodTypeDrap) {
                    // 拿到当前的上拉刷新控件，结束刷新状态
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }
                
            }else{
                if (refreshMethodType!=nil&&refreshMethodType==RRefreshMethodTypePull) {
                    //下拉刷新
                    [self.warns removeAllObjects];
                    // 拿到当前的上拉刷新控件，结束刷新状态
                    [self.tableView.mj_header endRefreshing];
                }
                if (refreshMethodType==RefreshMethodTypeDrap) {
                    // 拿到当前的上拉刷新控件，结束刷新状态
                    [self.tableView.mj_footer endRefreshing];
                }
                int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                if (tokenCode!=0) {
                    [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                }
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
            [self.tableView.mj_header endRefreshing];
        }
    }];
    
    
}

-(void)initTableviewAndData
{
    
    self.tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WarnCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"warnCellId"];
    self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 表格协议

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.warns.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WarnCell *cell=[tableView dequeueReusableCellWithIdentifier:@"warnCellId"];
    cell.warn=self.warns[indexPath.section];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

#pragma mark 懒加载
-(NSMutableArray *)warns
{
    if (_warns==nil) {
        _warns=[NSMutableArray array];
    }
    return _warns;
}


@end
