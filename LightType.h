//
//  LightType.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/15.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightType : NSObject

@property(nonatomic,assign) int typeId;
@property(nonatomic,strong) NSString *typeValue;

-initWithTypeId:(int)typeId withValue:(NSString *)value;

@end
