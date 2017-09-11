//
//  ViewTool.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewTool : UIViewController

+(id)initViewByStoryBordName:(NSString *) storyBordName withViewId:(NSString *)viewId;


+(NSString*)stringFromDate:(NSDate*)date;

+(NSDate*)dateFromString:(NSString*)dateString;
@end
