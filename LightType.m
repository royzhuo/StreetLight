//
//  LightType.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/15.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightType.h"

@implementation LightType

-(id)initWithTypeId:(int)typeId withValue:(NSString *)value
{
    self=[super init];
    if (self!=nil) {
        self.typeId=typeId;
        self.typeValue=value;
    }
    return self;
}

@end
