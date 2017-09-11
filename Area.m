//
//  Area.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/4.
//  Copyright © 2017年 street. All rights reserved.
//

#import "Area.h"

@implementation Area

-(id)initAreaWithId:(NSString *)selfId withAreaName:(NSString *)areaName withRegion:(int)isRegion withLevel:(int)level withParentId:(NSString *)parentId
{
    Area *area=[[Area alloc]init];
    area.selfId=selfId;
    area.name=areaName;
    area.isRegion=isRegion;
    area.level=level;
    area.parentId=parentId;
    return area;
}
@end
