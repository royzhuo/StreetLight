//
//  LightAddViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/14.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErWeiMaViewController.h"

@protocol LightAddViewDelegate <NSObject>

-(void) setLightAddViewType:(ErWeiMaType)erWeiMaType withParams:(NSMutableDictionary *)params;

-(void) isLightAddSuccess:(BOOL) isSuccess withLatitude:(double)lightLatitude withLongitude:(double)lightLongitude;


@end

@interface LightAddViewController : UIViewController

@property(nonatomic,assign) double latitude;//纬度

@property(nonatomic,assign) double longitude;//纬度

@property(nonatomic,strong) NSString *searchAddress;//位置信息

@property(nonatomic,strong) NSString *city;

@property(nonatomic,strong) NSString *ludengErWeiMa;

@property(nonatomic,strong) NSString *batteryErWeiMa;

@property (weak, nonatomic) IBOutlet UITableView *tabeView;

@property(nonatomic,strong) id<LightAddViewDelegate> delegate;

@end
