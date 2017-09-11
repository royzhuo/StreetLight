//
//  Cities.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/4.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cities : NSObject

@property(nonatomic,assign) BOOL isClicked;

@property(nonatomic,strong) NSMutableArray *areas;

@property(nonatomic,strong) NSString *name;

@property(nonatomic,assign) int isRegion;

@property(nonatomic,assign) int level;

@property(nonatomic,strong) NSString *selfId;

@property(nonatomic,strong) NSString *parentId;

@property(nonatomic,strong) NSMutableArray *lights;


-(id)initCityWithId:(NSString *) selfId withCityName:(NSString *)cityName withRegion:(int) isRegion withLevel:(int)level withParentId:(NSString *)parentId;

@end
