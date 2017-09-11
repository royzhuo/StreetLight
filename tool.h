//
//  tool.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/25.
//  Copyright © 2017年 street. All rights reserved.
//

#ifndef tool_h
#define tool_h

//颜色
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#define CGColorRGB(R,G,B) [[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]CGColor]

//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//屏幕高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕边框
#define ScreenFrame [UIScreen mainScreen].bounds

#define YLSRect(x, y, w, h)  CGRectMake([UIScreen mainScreen].bounds.size.width * x, [UIScreen mainScreen].bounds.size.height * y, [UIScreen mainScreen].bounds.size.width * w,  [UIScreen mainScreen].bounds.size.height * h)
#define YLSColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//屏幕尺寸

#define IPHONE4 (([UIScreen mainScreen].bounds.size.width == 320) && ([UIScreen mainScreen].bounds.size.height == 480))

#define IPHONE5 (([UIScreen mainScreen].bounds.size.width == 320) && ([UIScreen mainScreen].bounds.size.height == 568))

#define IPHONE6 (([UIScreen mainScreen].bounds.size.width == 375) && ([UIScreen mainScreen].bounds.size.height == 667))

#define IPHONE6P (([UIScreen mainScreen].bounds.size.width == 414) && ([UIScreen mainScreen].bounds.size.height == 736))

//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}

//分页
#define pageSize 10

#endif 
