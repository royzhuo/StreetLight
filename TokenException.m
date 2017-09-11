//
//  TokenException.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/9/7.
//  Copyright © 2017年 street. All rights reserved.
//

#import "TokenException.h"

#import "LoginController.h"
#import "AllWarnViewController.h"

@interface TokenException()<TokenDelegate>


@end

@implementation TokenException
DEF_SINGLETON(HttpTool)

-(void)tokenExcetionWithTarget:(UIViewController *)viewTarget withMsg:(int)msg
{
    if (msg==1||msg==2||msg==3) {
        
        LoginController *loginViewController=[ViewTool initViewByStoryBordName:@"Login" withViewId:@"login"];
        loginViewController.tokenDelegate=self;
        [viewTarget presentViewController:loginViewController animated:YES completion:^{
            [[User sharedInstance] clearUser];
        }];
        
    }


}
//协议
-(void)notifyReLoginWithSuccess:(BOOL)reloginSuccess
{
    if (reloginSuccess) {
        NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        [notificationCenter postNotificationName:@"reGetToken" object:nil userInfo:params];
    }


}

+(UIViewController *)currentViewController {
    UIViewController * result;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray * windows = [UIApplication sharedApplication].windows;
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView * frontView = window.subviews.firstObject;
    UIResponder * nextResponder = frontView.nextResponder;
    if ([nextResponder isKindOfClass:[UITabBarController class]]) {
        result = (UITabBarController *)nextResponder;
    }
    else {
        result = window.rootViewController;
    }
    return result;
}

@end
