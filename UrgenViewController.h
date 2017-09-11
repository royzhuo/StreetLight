//
//  UrgenViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,RefreshMethodType){
    RRefreshMethodTypePull=1,//下拉
    RefreshMethodTypeDrap=2      //上拉
};
@interface UrgenViewController : UIViewController

@property(nonatomic,strong) UITableView *tableView;

@end
