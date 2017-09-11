//
//  WarnWatchController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import "WarnWatchController.h"

#import "AllWarnViewController.h"

#import "UrgenViewController.h"

#import "NormalViewController.h"

@interface WarnWatchController ()<UIScrollViewDelegate>
{
    UIButton *nearbyBtn;
    UIButton *allWarnBtn;//所有警告
    UIButton *urgenWarntBtn;//紧急警告
    UIButton *normalWarnBtn;//一般警告
    UIView *line;//线
    
    UIScrollView *mainScrollerView;//滚动视图
    
    UIScrollView *scrollerView;//滑动视图
    
    
}

@property(nonatomic,strong) UIView *topMenuView;
@property(nonatomic,strong) UIScrollView *scrollerViews;

@property(nonatomic,strong) AllWarnViewController *allWarnController;
@property(nonatomic,strong) UrgenViewController *urgenController;
@property(nonatomic,strong) NormalViewController *normalController;

@end

@implementation WarnWatchController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTopMenuView];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.allWarnController=[[AllWarnViewController alloc]init];
    self.urgenController=[[UrgenViewController alloc]init];
    self.normalController=[[NormalViewController alloc]init];
    
    [self setMainSrollView];
    
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=@"警告控制";
}

#pragma mark 顶部菜单

-(void)initTopMenuView
{
    self.topMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,self.navigationController.navigationBar.frame.size.height+4)];
    self.topMenuView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.topMenuView];
    
    allWarnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    allWarnBtn.frame=CGRectMake(0, 0, ScreenWidth/3, self.topMenuView.frame.size.height-4);
    [allWarnBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [allWarnBtn setTitle:@"所有警告" forState:UIControlStateNormal];
    allWarnBtn.tag=1;
    [allWarnBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenuView addSubview:allWarnBtn];
    
    
    urgenWarntBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    urgenWarntBtn.frame=CGRectMake(allWarnBtn.frame.size.width, 0, allWarnBtn.frame.size.width, allWarnBtn.frame.size.height);
    [urgenWarntBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [urgenWarntBtn setTitle:@"紧急警告" forState:UIControlStateNormal];
    urgenWarntBtn.tag=2;
    urgenWarntBtn.alpha=0.8;
    [urgenWarntBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenuView addSubview:urgenWarntBtn];
    
    normalWarnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    normalWarnBtn.frame=CGRectMake(allWarnBtn.frame.size.width*2, 0, allWarnBtn.frame.size.width, allWarnBtn.frame.size.height);
    [normalWarnBtn setTitle:@"一般警告" forState:UIControlStateNormal];
    [normalWarnBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    normalWarnBtn.alpha=0.4;
    normalWarnBtn.tag=3;
    [normalWarnBtn addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topMenuView addSubview:normalWarnBtn];
    
    
    allWarnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    normalWarnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    urgenWarntBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    line=[[UIView alloc]initWithFrame:CGRectMake(0, self.topMenuView.frame.size.height-4, allWarnBtn.frame.size.width, 4)];
    line.backgroundColor=RGB(0, 205, 102);
    [self.topMenuView addSubview:line];
    

    

}

-(void)setMainSrollView{
    mainScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,self.topMenuView.frame.size.height, ScreenWidth,self.view.frame.size.height-self.topMenuView.frame.size.height-self.tabBarController.tabBar.frame.size.height-64)];
    
    float tabh=self.tabBarController.tabBar.frame.size.height;
    float th=self.topMenuView.frame.size.height;
    float vf=self.view.frame.size.height;
    mainScrollerView.delegate = self;
    mainScrollerView.backgroundColor = [UIColor whiteColor];
    mainScrollerView.pagingEnabled = YES;
    mainScrollerView.showsHorizontalScrollIndicator = NO;
    mainScrollerView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScrollerView];
    
    
    
    
    NSArray *views = @[self.allWarnController.view,self.urgenController.view,self.normalController.view];
    
    for (NSInteger i = 0; i<views.count; i++) {
        //把三个vc的view依次贴到mainScrollView上面
        UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, mainScrollerView.frame.size.width, mainScrollerView.frame.size.height)];
        [pageView addSubview:views[i]];
        [mainScrollerView addSubview:pageView];
    
    }
    self.allWarnController.tableView.frame=CGRectMake(0,0 , ScreenWidth,mainScrollerView.frame.size.height);
    self.urgenController.tableView.frame=CGRectMake(0,0 , ScreenWidth,mainScrollerView.frame.size.height);
    self.normalController.tableView.frame=CGRectMake(0,0 , ScreenWidth,mainScrollerView.frame.size.height);
    mainScrollerView.contentSize = CGSizeMake(ScreenWidth*(views.count), 0);
    //滚动到_currentIndex对应的tab
    [mainScrollerView setContentOffset:CGPointMake((mainScrollerView.frame.size.width)*_currentIndex, 0) animated:YES];
    
}

#pragma mark 滚动视图协议

//视图一滚动就执行
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实时计算当前位置,实现和titleView上的按钮的联动
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    CGFloat X = contentOffSetX * (3*ScreenWidth/3)/ScreenWidth/3;
    CGRect frame = line.frame;
    frame.origin.x = X;
    line.frame = frame;
    if ((scrollView.contentOffset.x/self.view.frame.size.width)==1) {
        [self notifyLoadData:2];
        
    }
    if ((scrollView.contentOffset.x/self.view.frame.size.width)==2) {
        [self notifyLoadData:3];
    }
}

-(void)notifyLoadData:(int)pageNo
{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [params setObject:[NSString stringWithFormat:@"true"] forKey:@"isUpdate"];
    [notificationCenter postNotificationName:@"updateWarnData" object:nil userInfo:params];

}

//滚动结束时执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contentOffSetX = scrollView.contentOffset.x;
    //判断当前第几页
    int index_ = contentOffSetX/ScreenWidth;
    [self sliderWithTag:index_+1];
}

#pragma mark 页面跳转

-(void)sliderAction:(UIButton *)sender{
    if (self.currentIndex==sender.tag) {
        return;
    }
    [self sliderAnimationWithTag:sender.tag];
    [UIView animateWithDuration:0.3 animations:^{
        mainScrollerView.contentOffset = CGPointMake(ScreenWidth*(sender.tag-1), 0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)sliderAnimationWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    allWarnBtn.selected = NO;
    urgenWarntBtn.selected = NO;
    normalWarnBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        line.frame = CGRectMake(sender.frame.origin.x, line.frame.origin.y, line.frame.size.width, line.frame.size.height);
        
    } completion:^(BOOL finished) {
        allWarnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        urgenWarntBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        normalWarnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }];
}

-(void)sliderWithTag:(NSInteger)tag{
    self.currentIndex = tag;
    allWarnBtn.selected = NO;
    normalWarnBtn.selected = NO;
    urgenWarntBtn.selected = NO;
    UIButton *sender = [self buttonWithTag:tag];
    sender.selected = YES;
    //动画
    line.frame = CGRectMake(sender.frame.origin.x, line.frame.origin.y, line.frame.size.width, line.frame.size.height);
    allWarnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    normalWarnBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    urgenWarntBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:19];
}

-(UIButton *)buttonWithTag:(NSInteger )tag{
    if (tag==1) {
        return allWarnBtn;
    }else if (tag==2){
        return urgenWarntBtn;
    }else if (tag==3){
        return normalWarnBtn;
    }else{
        return nil;
    }
}

@end
