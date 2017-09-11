//
//  Light.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/9.
//  Copyright © 2017年 street. All rights reserved.
//

#import "Light.h"

@implementation Light

-(id)initWithTitleIcon:(NSString *)titleIcon withTile:(NSString *)title withLightCode:(NSString *)lightCode withLightAddress:(NSString *)lightAddress
{
    self=[super init];
    if (self!=nil) {
        self.titleIcon=titleIcon;
        _title=title;
        _lightCode=lightCode;
        _lightAddress=lightAddress;
    }
    return self;
}

-(id)initWithLightId:(NSString *)lightId withPId:(NSString *)pId withAddress:(NSString *)address withLamnum:(NSString *)lamnum withIsRegion:(BOOL)isRegion withName:(NSString *)name withWorkMode:(NSString *)workmode withLampstate:(int)lamstate withGwid:(NSString *)gwid withLight:(int)light withLampwork:(int)lampwork withWorkstate:(int)workstate
{
    self=[super init];
    if (self!=nil) {
        self.lightId=lightId;
        self.pId=pId;
        self.lightAddress=address;
        self.lampnum=lamnum;
        self.isRegion=isRegion;
        self.title=name;
        self.workmode=workmode;
        self.lampstate=lamstate;
        self.gwid=gwid;
        self.light=light;
        self.workstate=workstate;
        
    }
    return self;
    
}

@end
