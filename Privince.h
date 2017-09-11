//
//  Privince.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/4.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Privince : NSObject

@property(nonatomic,assign) BOOL isClicked;

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSMutableArray *citys;

@property(nonatomic,strong) NSMutableArray *lights;

@property(nonatomic,strong) NSMutableArray *thirdDatas;

@property(nonatomic,assign) int isRegion;

@property(nonatomic,assign) int level;

@property(nonatomic,strong) NSString *selfId;

@property(nonatomic,strong) NSString *parentId;


-(id)initPrivinceWithId:(NSString *) pId withPrivinceName:(NSString *)privinceName withRegion:(int) isRegion withLevel:(int)level withParentId:(NSString *)parentId;

/*
 
 id = ffffffffffffffffffffffffffffffff;
 isRegion = 1;
 level = 0;
 name = "\U672a\U5206\U7ec4\U533a\U57df";
 pId = "";
 
 */
@end
