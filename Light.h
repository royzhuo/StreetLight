//
//  Light.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/9.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Light : NSObject

@property(nonatomic,strong) NSString *titleIcon;
@property(nonatomic,strong) NSString *title; //路灯名称
@property(nonatomic,strong) NSString *lightCode;
@property(nonatomic,strong) NSString *lightAddress;//路灯安装位置

@property(nonatomic,strong) NSString *lightId;
@property(nonatomic,strong) NSString *pId;
@property(nonatomic,strong) NSString *lampnum;
@property(nonatomic,assign) BOOL isRegion;
@property(nonatomic,strong) NSString *workmode;
@property(nonatomic,assign) int lampstate;
@property(nonatomic,strong) NSString *gwid;
@property(nonatomic,assign) int light;
@property(nonatomic,assign) int lampwork;
@property(nonatomic,assign) int workstate;


-(id)initWithTitleIcon:(NSString *) titleIcon withTile:(NSString *)title withLightCode:(NSString *)lightCode withLightAddress:(NSString *)lightAddress;

-(id)initWithLightId:(NSString *)lightId withPId:(NSString *)pId withAddress:(NSString *)address withLamnum:(NSString *)lamnum withIsRegion:(BOOL) isRegion withName:(NSString *)name withWorkMode:(NSString *) workmode withLampstate:(int) lamstate withGwid:(NSString *)gwid withLight:(int)light withLampwork:(int)lampwork withWorkstate:(int) workstate;
@end
