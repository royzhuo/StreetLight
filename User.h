//
//  User.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/28.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
AS_SINGLETON(User)


@property(nonatomic,strong) NSString *appuser;//账户
@property(nonatomic,strong) NSString *apppwd;//密码
@property(nonatomic,strong) NSString *guardiancode;//维护人员编码
@property(nonatomic,strong) NSString *guardianname;//维护人员名称
@property(nonatomic,strong) NSString *id;//标示
@property(nonatomic,strong) NSString *inccode;//所属企业
@property(nonatomic,strong) NSString *mark;//备注
@property(nonatomic,strong) NSData *regtime;//注册时间
@property(nonatomic,strong) NSString *tel;//电话
@property(nonatomic,strong) NSString *token;//电话吧

-(void) clearUser;

@end
