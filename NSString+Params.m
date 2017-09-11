//
//  NSString+Params.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/1.
//  Copyright © 2017年 street. All rights reserved.
//

#import "NSString+Params.h"

@implementation NSString (Params)

+(BOOL)isCheckNull:(NSString *)param
{
    if (param!=NULL) {
        return [param isEqualToString:@""];
    }else return false;
    
}
+(BOOL) isCheckNullByArray:(NSArray *)params
{
    if (params!=nil&&params.count>0) {
        
        for (int i=0; i<params.count; i++) {
            NSString *param=[params[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([param isEqualToString:@""]) {
                return true;
            }
        }
    }else{
        return false;
    
    }
    return false;
}

//判断路灯编码格式是否正确
+(BOOL)isCheckLampNum:(NSString *)lampNum
{
    
    NSString * regex = @"^[A-Fa-f0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:lampNum];

    return isMatch;

}
@end
