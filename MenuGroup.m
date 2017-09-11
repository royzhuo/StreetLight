//
//  MenuGroup.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/17.
//  Copyright © 2017年 street. All rights reserved.
//

#import "MenuGroup.h"

@implementation MenuGroup

-(id)initWithId:(NSString *)mId withPid:(NSString *)Pid withLevel:(int)level withIsRegion:(BOOL)isRegion withName:(NSString *)name
{
    self=[super init];
    if (self!=nil) {
        self.menuGroupId=mId;
        self.level=level;
        self.pId=Pid;
        self.isRegion=isRegion;
        self.name=name;
    }
    return self;
}

@end
