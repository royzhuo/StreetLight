//
//  LightManagerControllerViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"
#import "MapViewController.h"

@protocol ListReloadDataDelegate;

@interface LightManagerController: UIViewController

@property(nonatomic,assign) id<ListReloadDataDelegate> listDelegate;
@property(nonatomic,strong)MapViewController *mapViewController;

@property(nonatomic,strong)ListViewController *listViewController;
@end

//点击侧滑菜单，触发加载相应的数据在列表上
@protocol ListReloadDataDelegate <NSObject>

-(void)reloadListDataByInccode:(NSString *)inccode withRegioncode:(NSString *) regioncode;

@end