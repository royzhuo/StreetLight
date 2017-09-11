//
//  LightMap.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/15.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightMap : NSObject

@property(nonatomic,assign) double latitude;//纬度

@property(nonatomic,assign) double longitude;//纬度

-(id)initWithLatitude:(double)latitude withLongitude:(double)longitude;

@end
