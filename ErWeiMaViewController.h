//
//  ErWeiMaViewController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/13.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger,ErWeiMaType){
    
    ErWeiMaTypeLight=1,
    ErWeiMaTypeBattery=2,
    ErWeiMaTypeLightUpdate=3
};

@protocol ErWeiMaCodeDelegate<NSObject>

-(void)getErWeiMaValueWithLightCode:(NSString *)lightCode OrBatterCode:(NSString *)batteryCode withAddress:(NSString *)address withCity:(NSString *)city withLongitude:(double)longitude withlatitude:(double)latitude withLightParams:(NSMutableDictionary *)params;

-(void) setBatterCode:(NSString *)lightUpdateBatteryCode;

@end
@interface ErWeiMaViewController : UIViewController

@property(nonatomic,assign) double latitude;//纬度

@property(nonatomic,assign) double longitude;//纬度

@property(nonatomic,assign) NSString *city;//城市

@property(nonatomic,assign) NSString *searchAddress;//位置信息

@property(nonatomic,strong) AVCaptureDevice *device;//输入设备
 
@property (strong,nonatomic)AVCaptureDeviceInput * input;//输入数据源
@property (strong,nonatomic)AVCaptureMetadataOutput * output;//输出数据源
@property (strong,nonatomic)AVCaptureSession * session;//用于协调输入与输出之间的数据流
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;//提供摄像头的预览功能

@property(assign,nonatomic) ErWeiMaType erWeiMaType;
@property(strong,nonatomic) id<ErWeiMaCodeDelegate> delegate;

@end
