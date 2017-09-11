//
//  ViewTool.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import "ViewTool.h"

@implementation ViewTool

+(id)initViewByStoryBordName:(NSString *)storyBordName withViewId:(NSString *)viewId
{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:storyBordName bundle:nil];
    UIViewController *view=[storyBoard instantiateViewControllerWithIdentifier:viewId];
    return view;
}


+(NSString*)stringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    return [dateFormatter stringFromDate:date];
}
+(NSDate*)dateFromString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    
    return [dateFormatter dateFromString:dateString];
}



@end
