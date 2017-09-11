//
//  Area.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/4.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Area : NSObject

@property(nonatomic,assign) int isRegion;

@property(nonatomic,assign) int level;

@property(nonatomic,strong) NSString *selfId;

@property(nonatomic,strong) NSString *parentId;

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSMutableArray *lights;

@property(nonatomic,assign) BOOL isClicked;



-(id)initAreaWithId:(NSString *) selfId withAreaName:(NSString *)areaName withRegion:(int) isRegion withLevel:(int)level withParentId:(NSString *)parentId;

@end
