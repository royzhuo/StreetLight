//
//  LoginController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/26.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LoginController.h"
#import <Masonry.h>
#include <sys/sysctl.h>  
#include <net/if.h> 
#include <net/if_dl.h>
#import "AFNetworking.h"
#import "SysInfoUpdate.h"

#define logoWidth 150
#define logoHeight 150
#define viewInitX 100
#define viewInitY 80

@interface LoginController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation LoginController

#pragma mark 视图
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //添加背景图片
    UIImageView *backgroundView=[[UIImageView alloc]initWithFrame:self.view.frame];
    backgroundView.image=[UIImage imageNamed:@"bg"];

    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.tableview.backgroundView=backgroundView;
    self.v.backgroundColor=[UIColor clearColor];
    [self.v setFrame:[[UIScreen mainScreen]bounds]];

    CGRect vf=self.v.frame;
    
    self.nameView.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.nameView.layer.borderWidth=1.0f;
    self.nameView.layer.cornerRadius=22;
    self.nameView.layer.masksToBounds=YES;
    self.userNameTextField.borderStyle=UITextBorderStyleNone;
    [self.userNameTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.pwdView.layer.borderColor=[[UIColor whiteColor]CGColor];
    self.pwdView.layer.borderWidth=1.0f;
    self.pwdView.layer.cornerRadius=22;
    self.pwdView.layer.masksToBounds=YES;
    self.pwdTextField.borderStyle=UITextBorderStyleNone;
    [self.pwdTextField setSecureTextEntry:YES];
[self.pwdTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.loginBtn.backgroundColor=RGB(0, 205, 102);
    
    self.loginBtn.layer.cornerRadius=20;
    
    self.logoView.image=[UIImage imageNamed:@"logo"];
    
//    UIView *contentView=[[UIView alloc]initWithFrame:self.tableview.frame];
//    self.tableview.tableHeaderView=contentView;
//    //1.logo视图
//        UIImageView *logoView=[[UIImageView alloc]init];
//        logoView.frame=CGRectMake(contentView.frame.size.width/2-logoWidth/2, contentView.frame.origin.y+100, logoWidth , logoHeight);
//        logoView.image=[UIImage imageNamed:@"logo"];
//        [contentView addSubview:logoView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

#pragma mark验证和登录
-(BOOL)checkParams
{
    if ([self.userNameTextField.text isEqualToString:@""]) {
        [self showMessageTip:@"用户名不能为空" detail:nil timeOut:0.3f];
        return false;
    }
    if ([self.pwdTextField.text isEqualToString:@""]) {
        [self showMessageTip:@"用户密码不能为空" detail:nil timeOut:0.3f];
        return false;
    }
    if ( [self macaddress]==nil||[[self macaddress] isEqualToString:@""]) {
        [self showMessageTip:@"用户名不能为空" detail:nil timeOut:0.3f];
        return false;
    }
    return true;
}

-(void) userLogin
{
    if ([self checkParams]) {
        
        //检查网络配置信息
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        NSString *pingtaiIp=[userDefaults valueForKey:@"pingtaiIP"];
        NSString *pingtaiPort=[userDefaults valueForKey:@"pingtaiPort"];
        NSString *serverIP=[userDefaults valueForKey:@"serverIP"];
        NSString *serverPort=[userDefaults valueForKey:@"serverPort"];
        if (pingtaiIp==nil||pingtaiPort==nil||serverIP==nil||serverPort==nil) {
            SysInfoUpdate *paramsViews=[ViewTool initViewByStoryBordName:@"SystemSetting" withViewId:@"sysInfo"];
            paramsViews.sysInfoType=SysSettingTypeUpdateParams;
            paramsViews.title=@"参数配置";
            [self presentViewController:paramsViews animated:YES completion:nil];
        }else{
            //登录动作
            NSString *macAddres=[self macaddress];
            NSLog(@"mac地址:%@-----",macAddres);
            NSString *userName=self.userNameTextField.text;
            NSString *pwd=self.pwdTextField.text;
            //    NSDictionary *params=@{
            //                           @"appuser":userName,
            //                           @"apppwd":pwd,
            //                           @"mac":macAddres};
            NSDictionary *params2=@{
                                    @"phone":self.userNameTextField.text,
                                    @"pwd":self.pwdTextField.text
                                    };
            
            
            
            NSString *params=[NSString stringWithFormat:@"?appuser=%@&apppwd=%@&mac=%@",userName,pwd,macAddres];
            [self showLoaddingTip:@"登入中....." timeOut:0.3f];
            
            [[HttpTool sharedInstance]Post:login params:params success:^(id responseObj) {
                if (responseObj) {
                    
                    NSLog(@"success:%@---%@",responseObj,params);
                    
                }
                NSDictionary *result=[responseObj objectForKey:@"result"];
                int isSuccess=[[responseObj valueForKey:@"success"]integerValue];
                if (isSuccess==1) {
                    [self showSuccessTip:@"登入成功" timeOut:0.3f];
                    
                    NSString *token=[responseObj valueForKey:@"token"];
                    [User sharedInstance].token=token;
                    [User sharedInstance].id=[result valueForKey:@"id"];
                    [User sharedInstance].appuser=[result valueForKey:@"appuser"];
                    [User sharedInstance].apppwd=self.pwdTextField.text;
                    [User sharedInstance].mark=[result valueForKey:@"mark"];
                    [User sharedInstance].guardianname=[result valueForKey:@"guardianname"];
                    [User sharedInstance].guardiancode=[result valueForKey:@"guardiancode"];
                    [User sharedInstance].regtime=[result valueForKey:@"regtime"];
                    [User sharedInstance].inccode=[result valueForKey:@"inccode"];
                    [User sharedInstance].tel=[result valueForKey:@"tel"];
                    NSUserDefaults *loginToken=[NSUserDefaults standardUserDefaults];
                    [loginToken setObject:token forKey:@"loginToken"];
                    
                    //配置用户信息
                    [loginToken setObject:[result valueForKey:@"id"] forKey:@"id"];
                    [loginToken setObject:[result valueForKey:@"appuser"] forKey:@"appuser"];
                    [loginToken setObject:self.pwdTextField.text forKey:@"apppwd"];
                    [loginToken setObject:[result valueForKey:@"mark"] forKey:@"mark"];
                    [loginToken setObject:[result valueForKey:@"guardianname"] forKey:@"guardianname"];
                    [loginToken setObject:[result valueForKey:@"guardiancode"] forKey:@"guardiancode"];
                    [loginToken setObject:[result valueForKey:@"regtime"] forKey:@"regtime"];
                    [loginToken setObject:[result valueForKey:@"inccode"] forKey:@"inccode"];
                    [loginToken setObject:[result valueForKey:@"tel"] forKey:@"tel"];
                    //协议
                    [self.tokenDelegate notifyReLoginWithSuccess:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                if (isSuccess==0) {
                    int msg=[[responseObj objectForKey:@"msg"]integerValue];
                    
                    if (msg==0) {
                        [self showFailureTip:@"密码错误" detail:nil timeOut:0.3f];
                        return ;
                    }
                    if (msg==2) {
                        [self showFailureTip:@"没有该用户" detail:nil timeOut:0.3f];
                        return ;
                    }
                    if (msg!=NULL) {
                        return ;
                    }
                }
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"error:%@",error);
                }
            }];
        }
    }


    
    
    
    
  //  NSString *loginrul=[NSString stringWithFormat:@"%@?"]
    

    //AFN管理者调用get请求方法
//    [[self sharedManager] POST:@"http://192.168.9.57:9001/lampapi/api/appUser/login" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//        //返回请求返回进度
//        NSLog(@"downloadProgress-->%@",uploadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
//        //请求成功返回数据 根据responseSerializer 返回不同的数据格式
//        NSLog(@"responseObject-->%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //请求失败
//        NSLog(@"error-->%@",error);
//    }];

}



//获取mac地址
- (NSString *) macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

-(void)logg
{
    [self presentViewController:[ViewTool initViewByStoryBordName:@"Login" withViewId:@"ll"] animated:YES completion:nil];
}
#pragma mark table协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}








-(AFHTTPSessionManager *)sharedManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //最大请求并发任务数
    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    // 请求格式
    // AFHTTPRequestSerializer      二进制格式
    // AFJSONRequestSerializer      JSON
    // AFPropertyListRequestSerializer  PList(是一种特殊的XML,解析起来相对容易)
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    
    // 超时时间
    manager.requestSerializer.timeoutInterval = 30.0f;
    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // 设置接收的Content-Type
    manager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    // 返回格式
    // AFHTTPResponseSerializer      二进制格式
    // AFJSONResponseSerializer      JSON
    // AFXMLParserResponseSerializer   XML,只能返回XMLParser,还需要自己通过代理方法解析
    // AFXMLDocumentResponseSerializer (Mac OS X)
    // AFPropertyListResponseSerializer  PList
    // AFImageResponseSerializer     Image
    // AFCompoundResponseSerializer    组合
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//返回格式 JSON
    //设置返回C的ontent-type
    manager.responseSerializer.acceptableContentTypes=[[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
    
    return manager;
}

@end
