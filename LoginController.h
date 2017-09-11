//
//  LoginController.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TokenDelegate<NSObject>

-(void)notifyReLoginWithSuccess:(BOOL)reloginSuccess;

@end

@interface LoginController : UIViewController

//@property(nonatomic,strong) UITableView *tableView;


@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *v;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;


@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@property(nonatomic,strong) id<TokenDelegate> tokenDelegate;


@end
