//
//  MapViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/3.
//  Copyright © 2017年 street. All rights reserved.
//

#import "MapViewController.h"
#import "ErWeiMaViewController.h"
#import "LightMap.h"
#import "LightAddViewController.h"

@interface MapViewController()<AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,LightAddViewDelegate>
{
 double latitude;//纬度
double longitude;//纬度
     NSString *searchAddress;//位置信息
    NSMutableArray *mapLights;
}

@property(nonatomic,strong) MAPointAnnotation *pointAnnotation;

@end

@implementation MapViewController

-(void)viewDidLoad
{
    latitude=0;
    longitude=0;
    searchAddress=@"";
    mapLights=[NSMutableArray array];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    self.mapview= [[MAMapView alloc] initWithFrame:self.view.bounds];
    //地图缩放级别
    [self.mapview setZoomLevel:18 animated:YES];
    //显示蓝点
    self.mapview.showsUserLocation=YES;
    self.mapview.userTrackingMode=MAUserTrackingModeFollow;

    //添加定位图标
    self.dingweiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.dingweiBtn setImage:([UIImage imageNamed:@"dingwei_icon"]) forState:UIControlStateNormal];
    self.dingweiBtn.frame=CGRectMake(0, 300, 50, 50);
    self.dingweiBtn.backgroundColor=[UIColor whiteColor];
    self.dingweiBtn.layer.cornerRadius=20;
    self.dingweiBtn.layer.masksToBounds=YES;
    [self.dingweiBtn addTarget:self action:@selector(startDingWei) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.mapview];
    [self.view addSubview:self.dingweiBtn];
    
    
    
    //创建定位对象
    self.locationManager=[[AMapLocationManager alloc]init];
    self.locationManager.delegate=self;
    self.locationManager.distanceFilter=100;//设置最短距离
    self.locationManager.locatingWithReGeocode=YES;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        self.locationManager.allowsBackgroundLocationUpdates = NO;
    }
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    //开启定位
    [self.locationManager startUpdatingLocation];
    
    //创建手势
    self.clickGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPress:)];
    
    [self.mapview addGestureRecognizer:self.clickGesture];
    
    //设置标注点坐标
    self.mapview.delegate=self;
    
    //创建搜索信息
    self.mapSearchAPI=[[AMapSearchAPI alloc]init];
    self.mapSearchAPI.delegate=self;
    
    //通知
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(reloadView:) name:@"reGetToken" object:nil];
    
}

#pragma mark 通知
-(void)reloadView:(NSNotification *)notification
{
//    [self.locationManager startUpdatingLocation];
//    
//    self.mapview.userTrackingMode=MAUserTrackingModeFollow;
}

//开始定位
-(void)startDingWei
{
    NSLog(@"开始定位了");
    //开启定位
    [self.locationManager startUpdatingLocation];
    
    self.mapview.userTrackingMode=MAUserTrackingModeFollow;
}

#pragma mark 定位协议.地图协议 位置搜索
//获取定位信息
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    
    self.longitude=location.coordinate.longitude;
    self.latitude=location.coordinate.latitude;
    self.location=location;
    if (reGeocode)
    {
        NSLog(@"reGeocode:%@", reGeocode);
    }
    
    //多线程加载数据
    NSString *params=[NSString stringWithFormat:@"?latitude=%f&longitude=%f&toKen=%@",location.coordinate.latitude,location.coordinate.longitude,[User sharedInstance].token];
    [[HttpTool sharedInstance]Get:regionLamp params:params success:^(id responseObj) {
        if (responseObj) {
            NSLog(@"%@",responseObj);
                    BOOL isFindSuccess=[[responseObj valueForKey:@"success"]boolValue];
                    if (isFindSuccess) {
                        NSArray *results=[responseObj valueForKey:@"result"];
                        if (results!=nil&&results.count>0) {
                            NSMutableArray *tempPointAnnotion=[NSMutableArray array];
                            for (NSDictionary *result in results) {
                                
                                MAPointAnnotation *pointAnnotation=[[MAPointAnnotation alloc]init];
                                double latitude=[[result valueForKey:@"latitude"]doubleValue];
                                double longitude=[[result valueForKey:@"longitude"]doubleValue];
                                pointAnnotation.coordinate=CLLocationCoordinate2DMake(latitude, longitude);
                                [tempPointAnnotion addObject:pointAnnotation];
                            }
                                [self.mapview addAnnotations:tempPointAnnotion];
                        }
                    }else{
                        int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                        if (tokenCode!=0) {
                            [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                        }
                    }
        }
    } failure:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];

    
}
        
//生成标注对应的View
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    BOOL isyes=[annotation isKindOfClass:[MAUserLocation class]];
    if (![annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.image=[UIImage imageNamed:@"gz"];
        return annotationView;
        
    }
    return nil;
}
//逆地理编码回调
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        
        searchAddress=response.regeocode.formattedAddress;
        NSLog(@"点击的地址:%@",self.searchAddress);
        ErWeiMaViewController *erweimaview=(ErWeiMaViewController *)[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"erweima"];
        [self setMyMapViewDelegate:erweimaview];
        [self.myMapViewDelegate getAddress:searchAddress withCity:response.regeocode.addressComponent.city withLongitude:longitude withlatitude:latitude];
        erweimaview.erWeiMaType=ErWeiMaTypeLight;
        erweimaview.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:erweimaview animated:YES];
    }
}

#pragma mark 点击地图
-(void) tapPress:(UIGestureRecognizer *) gestureRecognizer
{
    
    CGPoint point=[gestureRecognizer locationInView:self.mapview];
    CLLocationCoordinate2D touchMapCoordinate=[self.mapview convertPoint:point toCoordinateFromView:self.mapview];
    
     NSLog(@"touching %.6f,%.6f",touchMapCoordinate.latitude,touchMapCoordinate.longitude);
    
    NSString *slat=[NSString stringWithFormat:@"%.6f",touchMapCoordinate.latitude];
    NSString *slong=[NSString stringWithFormat:@"%.6f",touchMapCoordinate.longitude];
    latitude=[slat doubleValue];
    longitude=[slong doubleValue];
    
    //设置逆地理编码查询参数
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    regeo.requireExtension= YES;
    //发起逆地理编码查询
    [self.mapSearchAPI AMapReGoecodeSearch:regeo];
    
    
}
#pragma mark 路灯添加成功返回的协议
-(void)isLightAddSuccess:(BOOL)isSuccess withLatitude:(double)lightLatitude withLongitude:(double)lightLongitude
{

    if (isSuccess) {
        MAPointAnnotation *pointAnnotation=[[MAPointAnnotation alloc]init];
        pointAnnotation.coordinate=CLLocationCoordinate2DMake(lightLatitude, lightLongitude);
        [self.mapview addAnnotation:pointAnnotation];
       
    }
}

@end
