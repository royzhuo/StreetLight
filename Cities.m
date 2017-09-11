//
//  Cities.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/4.
//  Copyright © 2017年 street. All rights reserved.
//

#import "Cities.h"

@implementation Cities


-(id)initCityWithId:(NSString *)selfId withCityName:(NSString *)cityName withRegion:(int)isRegion withLevel:(int)level withParentId:(NSString *)parentId
{
    Cities *city=[[Cities alloc]init];
    city.selfId=selfId;
    city.name=cityName;
    city.isRegion=isRegion;
    city.level=level;
    city.parentId=parentId;
    return city;
}
@end
