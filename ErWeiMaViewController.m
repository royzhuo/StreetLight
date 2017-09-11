//
//  ErWeiMaViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/13.
//  Copyright © 2017年 street. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "LightAddViewController.h"
#import "MapViewController.h"
#import "LightInfoUpdateController.h"

#define TOP (ScreenHeight-400)/2
#define LEFT (ScreenWidth-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@interface ErWeiMaViewController()<AVCaptureMetadataOutputObjectsDelegate,LightAddViewDelegate,MyMapViewDelegate,LightInfoDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    NSString *lightCity;
    NSMutableDictionary *lightParams;
}

@property (nonatomic, strong) UIImageView * line;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * queBtn;

@end

@implementation ErWeiMaViewController

-(void)viewDidLoad
{
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    //设备等信息初始化
    self.device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input=[AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output=[[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描区域
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    //连接输入输出
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //设置条码类型
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    //设置扫描区域
    CGFloat top = TOP/ScreenHeight;
    CGFloat left = LEFT/ScreenWidth;
    CGFloat width = 220/ScreenWidth;
    CGFloat height = 220/ScreenHeight;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    //添加扫描画面
    self.preview=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    [self.session startRunning];

    [self configView];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title=@"二维码";
    self.navigationController.navigationBar.hidden=YES;
//    [self setCropRect:kScanRect];
    //[self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
    
    NSArray *viewCOntrollers= self.navigationController.viewControllers;
    NSLog(@"%@",viewCOntrollers);
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
   // self.tabBarController.tabBar.hidden=NO;

}

-(void)setupCamera
{
    //设备等信息初始化
    self.device=[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.input=[AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    self.output=[[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置扫描区域
    CGFloat top = TOP/ScreenHeight;
    CGFloat left = LEFT/ScreenWidth;
    CGFloat width = 220/ScreenHeight;
    CGFloat height = 220/ScreenWidth;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    
    //连接输入输出
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    //设置条码类型
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    //添加扫描画面
    self.preview=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    
    [self.session startRunning];

}

- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}
-(void)configView{
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    
    //提示
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(LEFT+10, imageView.frame.origin.y-30, 180, 20)];
    title.textAlignment=NSTextAlignmentCenter;
    title.text=@"请将二维码放入框内扫描";
    title.textColor=[UIColor whiteColor];
    [title setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:title];
    
    UILabel *resultLable=[[UILabel alloc]initWithFrame:CGRectMake(LEFT+10, imageView.frame.origin.y+imageView.frame.size.height+5, 180, 18)];
    resultLable.textAlignment=NSTextAlignmentCenter;
    resultLable.text=@"扫描结果";
    resultLable.textColor=[UIColor whiteColor];
    [resultLable setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:resultLable];

    
    int textWidth=ScreenWidth-90;
    self.textField=[[UITextField alloc]initWithFrame:CGRectMake((ScreenWidth-textWidth)/2, resultLable.frame.origin.y+resultLable.frame.size.height+10, textWidth, 30)];
    self.textField.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.textField];
    
    int tuiChuBtnWidth=ScreenWidth-60;
    UIButton *tuiChuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tuiChuBtn.frame=CGRectMake((ScreenWidth-tuiChuBtnWidth)/2, self.textField.frame.origin.y+60, tuiChuBtnWidth, 40);
    [tuiChuBtn setTitle:@"确定" forState:UIControlStateNormal];
    [tuiChuBtn setTintColor:[UIColor whiteColor]];
    [tuiChuBtn setBackgroundColor:RGB(0, 205, 102)];
    tuiChuBtn.layer.cornerRadius=10;
    //添加点击事件
    [tuiChuBtn addTarget:self action:@selector(queding) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tuiChuBtn];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)queding
{
    LightAddViewController *lightAddViewController=[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"lightAdd"];
    self.delegate=lightAddViewController;
    if (self.erWeiMaType==ErWeiMaTypeLight) {

        [self.delegate getErWeiMaValueWithLightCode:self.textField.text OrBatterCode:nil withAddress:self.searchAddress withCity:lightCity withLongitude:self.longitude withlatitude:self.latitude withLightParams:lightParams];
        self.textField.text=@"";
        [self.navigationController pushViewController:lightAddViewController animated:YES];
    }
    if (self.erWeiMaType==ErWeiMaTypeBattery) {
        lightAddViewController.batteryErWeiMa=self.textField.text;
        [self.delegate getErWeiMaValueWithLightCode:nil OrBatterCode:self.textField.text withAddress:self.searchAddress withCity:lightCity withLongitude:self.longitude withlatitude:self.latitude withLightParams:lightParams];
        self.textField.text=@"";
        [self.navigationController pushViewController:lightAddViewController animated:YES];
    }
    if (self.erWeiMaType==ErWeiMaTypeLightUpdate) {
        if (self.navigationController!=nil&&self.navigationController.viewControllers!=nil&&self.navigationController.viewControllers.count>0) {
            for (UIViewController *viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[LightInfoUpdateController class]]) {
                    LightInfoUpdateController *lightUpdateViewController=(LightInfoUpdateController *)viewController;
                    self.delegate=lightUpdateViewController;
                    [self.delegate setBatterCode:self.textField.text];
                    [self.navigationController popToViewController:lightUpdateViewController animated:YES];
                }
            }
        }
    }
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        self.textField.text=stringValue;
        LightAddViewController *lightAddViewController=[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"lightAdd"];
        self.delegate=lightAddViewController;
        if (self.erWeiMaType==ErWeiMaTypeLight) {
            [self.delegate getErWeiMaValueWithLightCode:self.textField.text OrBatterCode:nil withAddress:self.searchAddress withCity:lightCity withLongitude:self.longitude withlatitude:self.latitude withLightParams:lightParams];
            self.textField.text=@"";
            [self.navigationController pushViewController:lightAddViewController animated:YES];
        }
        if (self.erWeiMaType==ErWeiMaTypeBattery) {
            lightAddViewController.batteryErWeiMa=self.textField.text;
                [self.delegate getErWeiMaValueWithLightCode:nil OrBatterCode:self.textField.text withAddress:self.searchAddress withCity:lightCity withLongitude:self.longitude withlatitude:self.latitude withLightParams:lightParams];
            self.textField.text=@"";
            [self.navigationController pushViewController:lightAddViewController animated:YES];
        }
        if (self.erWeiMaType==ErWeiMaTypeLightUpdate) {
            if (self.navigationController!=nil&&self.navigationController.viewControllers!=nil&&self.navigationController.viewControllers.count>0) {
                for (UIViewController *viewController in self.navigationController.viewControllers) {
                    if ([viewController isKindOfClass:[LightInfoUpdateController class]]) {
                        LightInfoUpdateController *lightUpdateViewController=(LightInfoUpdateController *)viewController;
                        self.delegate=lightUpdateViewController;
                        [self.delegate setBatterCode:self.textField.text];
                        [self.navigationController popToViewController:lightUpdateViewController animated:YES];
                    }
                }
            }
        }

        

        
        
    }
}


#pragma mark 个人业务协议
//判断是电池还是路灯
-(void)setLightAddViewType:(ErWeiMaType)erWeiMaType withParams:(NSMutableDictionary *)params
{
    if (erWeiMaType==ErWeiMaTypeLight) {
        self.erWeiMaType=ErWeiMaTypeLight;
    }
    if (erWeiMaType==ErWeiMaTypeBattery) {
        self.erWeiMaType=ErWeiMaTypeBattery;
    }
    lightParams=params;
    [self.session startRunning];

}
//获取点击的地址
-(void)getAddress:(NSString *)address withCity:(NSString *)city withLongitude:(double)longitude withlatitude:(double)latitude
{

    self.searchAddress=address;
    self.longitude=longitude;
    self.latitude=latitude;
    lightCity=city;
}

//路灯编辑协议
-(void)notifyErWeiMa:(ErWeiMaType)erWeiMaType
{
    self.erWeiMaType=erWeiMaType;
}


@end
