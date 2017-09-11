//
//  SlideMenuesViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/16.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Light.h"
@protocol SlideMenuesViewDataDelegate <NSObject>

-(void)reloadLightInfo:(Light *)light;

@end

@interface SlideMenuesViewController : UIViewController

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) id<SlideMenuesViewDataDelegate> delegate;

@end
