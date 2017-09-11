//
//  AllWarnControllerViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import "AllWarnViewController.h"
#import "Warn.h"
#import "WarnCell.h"
#import "MJRefreshAutoNormalFooter.h"
#import "MJRefreshNormalHeader.h"
#import "UrgenViewController.h"
#import "LoginController.h"
#import "WarnWatchController.h"

@interface AllWarnViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *warns;

@property(nonatomic,assign)int pageNo;

@end

@implementation AllWarnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self initTableviewAndData];
    [self footerRefresh];
    [self pullRefresh];
    //通知
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    //[notificationCenter addObserver:self selector:@selector(reloadView:) name:@"reGetToken" object:nil];
   }


#pragma mark 通知
-(void)reloadView:(NSNotification *)notification
{
    [self loadNewData];
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
    int height= self.view.frame.size.height;
    int y=self.view.frame.origin.y;
    NSLog(@"height:%d y:%d",height,y);
    
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
                        Warn *warn=[[Warn alloc]initWithAlarmtime:[[dic valueForKey:@"alarmtime"]longValue] withAlarmcontent:[dic valueForKey:@"alarmcontent"] withAlarmtype:[[dic valueForKey:@"alarmtype"]intValue] withWarnId:[dic valueForKey:@"id"] withInccode:[dic valueForKey:@"inccode"] withIshandle:[[dic valueForKey:@"ishandle"]intValue] withIsMsg:[[dic valueForKey:@"ismsg"]intValue] withName:[dic valueForKey:@"lampname"] withLamptype:[[dic valueForKey:@"lamptype"]intValue] withMsgTime:[[dic valueForKey:@"msgtime"]longValue] withRegionname:[dic valueForKey:@"regionname"]];
                        [self.warns addObject:warn];
                }
                NSLog(@"warns:%@",self.warns);
                [self.tableView reloadData];
                if (refreshMethodType==RefreshMethodTypeDrap) {
                    // 拿到当前的上拉刷新控件，结束刷新状态
                    [self.tableView.mj_footer endRefreshing];
                }
            }else{
                [self.tableView.mj_header endRefreshing];
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
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    

    
    
}

- (UIViewController *)currentViewController {
    UIViewController * result;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray * windows = [UIApplication sharedApplication].windows;
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView * frontView = window.subviews.firstObject;
    UIResponder * nextResponder = frontView.nextResponder;
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        result = (UITabBarController *)nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    return result;
}
-(void)initTableviewAndData
{


    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 200) style:UITableViewStylePlain];
    CGRect vf=self.view.frame;
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    cell.warn=self.warns[indexPath.section];
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
