//
//  LightMap.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/15.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightMap.h"

@implementation LightMap

-(id)initWithLatitude:(double)latitude withLongitude:(double)longitude
{
    self=[super init];
    if (self) {
        self.longitude=longitude;
        self.latitude=latitude;
    }
    return self;
}

@end
