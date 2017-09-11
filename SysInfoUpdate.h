//
//  SysInfoUpdate.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/31.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SysSettingType){

    SysSettingTypeUpdatePwd=1,
    SysSettingTypeUpdateParams=2
};

@protocol SysInfoUpdateDelegate <NSObject>

-(void) isUpdatePwd:(BOOL) isSuccess;

@end



@interface SysInfoUpdate : UIViewController

@property(nonatomic,assign) SysSettingType sysInfoType;
@property(nonatomic,strong) NSString *title;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property(nonatomic,strong)id<SysInfoUpdateDelegate> delegate;

@end
