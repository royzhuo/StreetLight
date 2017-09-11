//
//  LightInfoUpdate.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/9.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ErWeiMaViewController.h"

@protocol LightInfoDelegate <NSObject>

-(void) lightInfoUpdateIsSuccess:(BOOL) isSuccess;

-(void) notifyErWeiMa:(ErWeiMaType) erWeiMaType;

@end

@interface LightInfoUpdateController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(nonatomic,strong) NSDictionary *lightResult;

@property(nonatomic,strong) id<LightInfoDelegate> lightInfoDelegate;



@end
