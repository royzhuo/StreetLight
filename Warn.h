//
//  Warn.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Warn : NSObject

@property(nonatomic,strong)NSString *alarmcontent;

@property(nonatomic,assign)long alarmtime;
@property(nonatomic,assign)int alarmtype;

@property(nonatomic,strong)NSString *warnId;
@property(nonatomic,strong) NSString *inccode;
@property(nonatomic,assign) int ishandle;
@property(nonatomic,assign) int ismsg;

@property(nonatomic,strong) NSString *lampname;

@property(nonatomic,assign) int lamptype;
@property(nonatomic,assign) long msgtime;
@property(nonatomic,strong) NSString *regionname;

-initWithAlarmtime:(long)alarmtime withAlarmcontent:(NSString *)alarmcontent withAlarmtype:(int)alarmType withWarnId:(NSString *)warnId withInccode:(NSString *)inccode withIshandle:(int )ishandle withIsMsg:(int )ismsg withName:(NSString *)name withLamptype:(int)lamptype withMsgTime:(long)msgtime withRegionname:(NSString *)regionname;

@end


/*

 
 alarmcontent = "\U592a\U9633\U80fd\U677f\U6545\U969c";
 alarmtime = 1501127035000;
 alarmtype = 1;
 id = b8be5d3dd2604733863815714806d071;
 inccode = 1c34faaf3f0649c38417ba8a166c349e;
 ishandle = 1;
 ismsg = 1;
 lampcode = 5be8b6909b834b0791676c96f3ef0e0a;
 lampname = "\U5367\U5ba4\U706f1";
 lamptype = 7;
 msgtime = 1501127035000;
 regionname = "\U798f\U5efa\U7701";
 
*/