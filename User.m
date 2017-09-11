//
//  User.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/28.
//  Copyright © 2017年 street. All rights reserved.
//

#import "User.h"

@implementation User
DEF_SINGLETON(User)

-(void)clearUser
{
    self.id=nil;
    self.apppwd=nil;
    self.apppwd=nil;
    self.regtime=nil;
    self.guardiancode=nil;
    self.guardianname=nil;
    self.inccode=nil;
    self.mark=nil;
    self.tel=nil;
}
@end
