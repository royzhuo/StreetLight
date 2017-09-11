//
//  Warn.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import "Warn.h"

@implementation Warn

-(id)initWithAlarmtime:(long)alarmtime withAlarmcontent:(NSString *)alarmcontent withAlarmtype:(int)alarmType withWarnId:(NSString *)warnId withInccode:(NSString *)inccode withIshandle:(int)ishandle withIsMsg:(int)ismsg withName:(NSString *)name withLamptype:(int)lamptype withMsgTime:(long)msgtime withRegionname:(NSString *)regionname
{
    self=[super init];
    if (self) {
        self.alarmtime=alarmtime;
        self.alarmcontent=alarmcontent;
        self.alarmtype=alarmType;
        self.warnId=warnId;
        self.inccode=inccode;
        self.ishandle=ishandle;
        self.ismsg=ismsg;
        self.lampname=name;
        self.lamptype=lamptype;
        self.msgtime=msgtime;
        self.regionname=regionname;
    }
    
    return self;
}



@end
