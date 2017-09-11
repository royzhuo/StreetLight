//
//  MenuGroup.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/17.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuGroup : NSObject

@property(nonatomic,assign) BOOL isClicked;

@property(nonatomic,strong) NSString *name;

@property(nonatomic,strong) NSMutableArray *privinces;

@property(nonatomic,strong) NSMutableArray *cities;

@property(nonatomic,strong) NSMutableArray *lights;

@property(nonatomic,strong) NSMutableArray *secondDatas;//省的层级

@property(nonatomic,strong) NSString *menuGroupId;
@property(nonatomic,assign) int level;
@property(nonatomic,assign) BOOL isRegion;
@property(nonatomic,strong) NSString *pId;

-initWithId:(NSString *) mId withPid:(NSString *)Pid withLevel:(int ) level withIsRegion:(BOOL) isRegion withName:(NSString *)name;

@end
