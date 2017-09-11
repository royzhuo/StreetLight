//
//  NSString+Params.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/1.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Params)

+(BOOL) isCheckNull:(NSString *)param;
+(BOOL) isCheckNullByArray:(NSArray *) params;
+(BOOL) isCheckLampNum:(NSString *)lampNum;

@end
