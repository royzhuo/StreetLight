//
//  MapViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/3.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol MyMapViewDelegate <NSObject>

-(void) getAddress:(NSString *)address withCity:(NSString *)city withLongitude:(double)longitude withlatitude:(double)latitude;

@end

@interface MapViewController : UIViewController

@property(nonatomic,strong) MAMapView *mapview;

@property(nonatomic,strong) AMapLocationManager *locationManager;

@property(nonatomic,strong) MAUserLocationRepresentation *userLoactionRepresentation;

@property(nonatomic,strong) CLLocation *location;

@property(nonatomic,strong) UITapGestureRecognizer *clickGesture;//手势

@property(nonatomic,strong) UIButton *dingweiBtn;

@property(nonatomic,assign) double latitude;//纬度

@property(nonatomic,assign) double longitude;//纬度

@property(nonatomic,assign) NSString *searchAddress;//位置信息

@property(nonatomic,strong) AMapSearchAPI *mapSearchAPI;//搜索对象

@property(nonatomic, weak, nullable) id<MyMapViewDelegate> myMapViewDelegate;

@end
