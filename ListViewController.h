//
//  ListViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/3.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController 

@property(nonatomic,strong) UITableView *tableView;
//@property(nonatomic,strong) YiSlideMenu *slideMenu;

@property(nonatomic,assign) double latitude;//纬度

@property(nonatomic,assign) double longitude;//纬度

@end
