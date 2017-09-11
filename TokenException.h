//
//  TokenException.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/9/7.
//  Copyright © 2017年 street. All rights reserved.
//  处理token异常

#import <UIKit/UIKit.h>

@interface TokenException : UIViewController
AS_SINGLETON(TokenException)


-(void)tokenExcetionWithTarget:(UIViewController *)viewTarget withMsg:(int)msg;


+(UIViewController *)currentViewController;
@end
