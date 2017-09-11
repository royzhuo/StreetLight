//
//  NSObject+Tips.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/28.
//  Copyright © 2017年 street. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Tips)

- (void)showSuccessTip:(NSString *)string timeOut:(NSTimeInterval)interval;

- (void)showLoaddingTip:(NSString *)string timeOut:(NSTimeInterval)interval;

- (void)showLoaddingTip:(NSString *)string;

- (void)showFailureTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval;

- (void)showMessageTip:(NSString *)string detail:(NSString *)detail timeOut:(NSTimeInterval)interval;

-(void) dissmissTips;
@end
