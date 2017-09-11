//
//  Privince.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/4.
//  Copyright © 2017年 street. All rights reserved.
//

#import "Privince.h"

@implementation Privince

-(id)initPrivinceWithId:(NSString *)pId withPrivinceName:(NSString *)privinceName withRegion:(int)isRegion withLevel:(int)level withParentId:(NSString *)parentId
{
    Privince *privince=[[Privince alloc]init];
    privince.selfId=pId;
    privince.name=privinceName;
    privince.isRegion=isRegion;
    privince.level=level;
    privince.parentId=parentId;
    return privince;
}

@end
