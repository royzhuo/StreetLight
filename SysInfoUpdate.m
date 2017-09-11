    //
//  SysInfoUpdate.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/7/31.
//  Copyright © 2017年 street. All rights reserved.
//

#import "SysInfoUpdate.h"
#import "InfoTextField.h"

@interface SysInfoUpdate()<UITableViewDelegate,UITableViewDataSource>

{
    NSArray *pwdTitles;
    NSArray *paramTitles;
    NSMutableArray *textFieldTypes;
    NSString *oldPwd;
    NSString *newPwd;
    NSString *newPwd2;
    NSString *clientIP;
    NSString *clientPort;
    NSString *serverIP;
    NSString *serverPort;
}
@end

@implementation SysInfoUpdate

-(void)viewDidLoad
{
    oldPwd=@"";
    newPwd=@"";
    newPwd2=@"";
    clientIP=@"";
    clientPort=@"";
    serverIP=@"";
    serverPort=@"";
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    if (self.sysInfoType==SysSettingTypeUpdatePwd) {
        pwdTitles=@[@"原始密码:",@"修改密码:",@"确认密码:"];
    }
    if (self.sysInfoType==SysSettingTypeUpdateParams) {
        paramTitles=@[@"平台IP:",@"端   口:",@"服务IP:",@"端   口:"];
    }
    
    
    

}
//手势
-(void)fingerTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    [self.view endEditing:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title=self.title;
    
    
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"houtui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
    [leftButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableview.frame.size.width, 80)];
    
    UINavigationController *navigationControl=self.navigationController;
    if (navigationControl==nil) {
        UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 68)];
        topView.backgroundColor=RGB(0, 205, 102);
        float titleLabelWidth=ScreenWidth*0.4;
        float titleLabelHeight=topView.frame.size.height*0.5;
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-titleLabelWidth)/2, (topView.frame.size.height-titleLabelHeight)/2, titleLabelWidth, titleLabelHeight)];
        titleLabel.adjustsFontSizeToFitWidth=YES;
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.text=@"参数配置";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [topView addSubview:titleLabel];
        UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(0, (topView.frame.size.height-titleLabelHeight)/2, titleLabelWidth/2, titleLabelHeight);
        [backBtn setTitle:@"取消" forState:UIControlStateNormal];
        [backBtn setTintColor:[UIColor whiteColor]];
        [topView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(paramsViewBack) forControlEvents:UIControlEventTouchUpInside];
        self.tableview.tableHeaderView=topView;
    }
    
    UIButton *tuiChuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    int tuiChuBtnWidth=ScreenWidth-30;
    int tuiChuBtnHeight=footView.frame.size.height/2;
    tuiChuBtn.frame=CGRectMake((ScreenWidth-tuiChuBtnWidth)/2, tuiChuBtnHeight/2, tuiChuBtnWidth, tuiChuBtnHeight);
    [tuiChuBtn setTitle:@"确定" forState:UIControlStateNormal];
    [tuiChuBtn setTintColor:[UIColor whiteColor]];
    [tuiChuBtn setBackgroundColor:RGB(0, 205, 102)];
    tuiChuBtn.layer.cornerRadius=10;
    [footView addSubview:tuiChuBtn];
    //添加点击事件
    [tuiChuBtn addTarget:self action:@selector(updateinfo) forControlEvents:UIControlEventTouchUpInside];
    self.tableview.tableFooterView=footView;

}

-(void)paramsViewBack
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)leftView
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 更新
-(void)updateinfo
{
    if ([self checkParmas]) {
        if (self.sysInfoType==SysSettingTypeUpdatePwd) {
            //更新密码
            NSString *params=[NSString stringWithFormat:@"?userId=%@&toKen=%@&apppwd=%@&oldpwd=%@",[User sharedInstance].id,[User sharedInstance].token,newPwd,oldPwd];
            [[HttpTool sharedInstance]Post:updatePwd params:params success:^(id responseObj) {
                if (responseObj) {
                    BOOL isSuccess=[[responseObj valueForKey:@"success"]boolValue];
                    if(isSuccess){
                        [self showSuccessTip:@"更新成功" timeOut:0.3f];
                        [self.delegate isUpdatePwd:YES];
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        [User sharedInstance].apppwd=newPwd;
                    }else{
                        int msg=[[responseObj objectForKey:@"msg"]integerValue];
                        int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                        
                        if (msg==0) {
                            [self showFailureTip:@"更新失败" detail:nil timeOut:0.3f];
                            return ;
                        }
                        if (tokenCode!=0) {
                            [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                        }
                    }
                }
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
            }];
        }else{
            //更新参数
            Boolean ispingtaiNetwork=false;
            BOOL issocketNetwork=false;
            //1.检查照明网络
            NSString *pingtaiUrl=[NSString stringWithFormat:@"http://%@:%@",clientIP,clientPort];
            [HttpTool sharedInstance].baseUrl=pingtaiUrl;
            [[HttpTool sharedInstance] Get:checkNet params:nil success:^(id responseObj) {
                if (responseObj) {
                    
                    NSLog(@"%@",[[NSString alloc]initWithData:responseObj encoding:NSUTF8StringEncoding]);
                    [self showSuccessTip:[[NSString alloc]initWithData:responseObj encoding:NSUTF8StringEncoding] timeOut:0.3f];
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault setObject:clientIP forKey:@"pingtaiIP"];
                    [userDefault setObject:clientPort forKey:@"pingtaiPort"];
                    [userDefault setObject:pingtaiUrl forKey:@"pingtaiUrl"];
                    [HttpTool sharedInstance].pingtaiUrl=pingtaiUrl;
                    [HttpTool sharedInstance].checkPingtaiNet=200;
                    
                    //2.检查通信网络
                    NSString *socketUrl=[NSString stringWithFormat:@"http://%@:%@",serverIP,serverPort];
                    [HttpTool sharedInstance].baseUrl=socketUrl;
                    [[HttpTool sharedInstance] Get:checkNetSocket params:nil success:^(id responseObj) {
                        if (responseObj) {
                            
                            NSLog(@"%@",responseObj);
                            [self showSuccessTip:[responseObj valueForKey:@"msg"] timeOut:0.3f];
                            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                            [userDefault setObject:serverIP forKey:@"serverIP"];
                            [userDefault setObject:serverPort forKey:@"serverPort"];
                            [userDefault setObject:socketUrl forKey:@"serverUrl"];
                            [HttpTool sharedInstance].serverUrl=socketUrl;
                            [HttpTool sharedInstance].checkSocketNet=200;
                            if (([HttpTool sharedInstance].checkPingtaiNet==200)&&([HttpTool sharedInstance].checkSocketNet=200)) {
                                [HttpTool sharedInstance].baseUrl=pingtaiUrl;
                                if (self.navigationController==nil) {
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }else [self.navigationController popViewControllerAnimated:YES];
                                
                            }

                        }
                    } failure:^(NSError *error) {
                        if (error) {
                            NSLog(@"%@",error);
                            [self showFailureTip:@"通信网络有问题" detail:nil timeOut:0.3f];
                            NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                            [HttpTool sharedInstance].baseUrl=[userDefault valueForKey:@"pingtaiUrl"];
                            [HttpTool sharedInstance].pingtaiUrl=[userDefault valueForKey:@"pingtaiUrl"];
                            [HttpTool sharedInstance].serverUrl=[userDefault valueForKey:@"serverUrl"];
                            [HttpTool sharedInstance].checkSocketNet=500;
                            
                        }
                    }];
                }
            } failure:^(NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                    [self showFailureTip:@"平台网络有问题" detail:nil timeOut:0.3f];
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [HttpTool sharedInstance].baseUrl=[userDefault valueForKey:@"pingtaiUrl"];
                    [HttpTool sharedInstance].pingtaiUrl=[userDefault valueForKey:@"pingtaiUrl"];
                    [HttpTool sharedInstance].serverUrl=[userDefault valueForKey:@"serverUrl"];
                    [HttpTool sharedInstance].checkPingtaiNet=500;
                }
            }];
        }
    }
    
}



//check params
-(BOOL) checkParmas
{
    if (self.sysInfoType==SysSettingTypeUpdatePwd) {
        if( ![NSString isCheckNullByArray:@[oldPwd,newPwd,newPwd2]]){
            NSString *pwd=[User sharedInstance].apppwd;
            if (![oldPwd isEqualToString:[User sharedInstance].apppwd]) {
                [self showMessageTip:@"密码不对" detail:nil timeOut:0.3f];
                return false;
            }
            if(![newPwd isEqualToString:newPwd2]){
                [self showMessageTip:@"密码不一致" detail:nil timeOut:0.3f];
                return false;
            }
            return true;
        }else{
            [self showMessageTip:@"内容不能为空" detail:nil timeOut:0.3f];
            return false;
        }
    }
    if (self.sysInfoType==SysSettingTypeUpdateParams) {
        if( ![NSString isCheckNullByArray:@[clientPort,clientIP,serverPort,serverIP]]){
            return true;
        }else{
            [self showMessageTip:@"内容不能为空" detail:nil timeOut:0.3f];
            return false;
        }
    }
    return false;
}

//将离开这个页面
-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=NO;
    
}

//获取uitextfield信息
-(void)getTextFieldResult:(InfoTextField *)textField
{
    InfoTextFieldType type=textField.infoTextFieldType;
    NSLog(@"textField type:%@  value:%@",textField,textField.text);
    if (type==InfoTextFieldTypeOldPWD) {
        oldPwd=textField.text;
    }
    if (type==InfoTextFieldTypeNewPWD) {
        newPwd=textField.text;
    }
    
    if (type==InfoTextFieldTypeNewPWD2) {
        newPwd2=textField.text;
    }
    
    if (type==InfoTextFieldTypePingIP) {
        clientIP=textField.text;
    }
    
    if (type==InfoTextFieldTypePingPort) {
        clientPort=textField.text;
    }
    
    if (type==InfoTextFieldTypeServerIP) {
        serverIP=textField.text;
    }
    if (type==InfoTextFieldTypeServerPort) {
        serverPort=textField.text;
    }
    
    
}

#pragma mark  协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sysInfoType==SysSettingTypeUpdatePwd) {
        return pwdTitles.count;
    }
    else if (self.sysInfoType==SysSettingTypeUpdateParams) {
        return paramTitles.count;
    }else{
        return 0;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellId"];
    UILabel *titleLabel=(UILabel *)[cell viewWithTag:1000];
    InfoTextField *paramTextField=(InfoTextField *)[cell viewWithTag:2000];
    if (self.sysInfoType==SysSettingTypeUpdatePwd) {
        titleLabel.text=pwdTitles[indexPath.row];
        if (indexPath.row==0) {
            paramTextField.infoTextFieldType=InfoTextFieldTypeOldPWD;
            paramTextField.placeholder=@"填写原密码";
            paramTextField.secureTextEntry=YES;
        }
        if (indexPath.row==1) {
            paramTextField.infoTextFieldType=InfoTextFieldTypeNewPWD;
            paramTextField.placeholder=@"填写新密码";
            paramTextField.secureTextEntry=YES;
        }
        if (indexPath.row==2) {
            paramTextField.infoTextFieldType=InfoTextFieldTypeNewPWD2;
            paramTextField.placeholder=@"再填写一遍";
            paramTextField.secureTextEntry=YES;
        }

    }
    if (self.sysInfoType==SysSettingTypeUpdateParams) {
        titleLabel.text=paramTitles[indexPath.row];
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        if (indexPath.row==0) {
            paramTextField.infoTextFieldType=InfoTextFieldTypePingIP;
            if ([userDefaults valueForKey:@"pingtaiIP"]!=nil) {
                paramTextField.text=[userDefaults valueForKey:@"pingtaiIP"];
                clientIP=[userDefaults valueForKey:@"pingtaiIP"];
            }
        }
        if (indexPath.row==1) {
            paramTextField.infoTextFieldType=InfoTextFieldTypePingPort;
            if ([userDefaults valueForKey:@"pingtaiPort"]!=nil) {
                paramTextField.text=[userDefaults valueForKey:@"pingtaiPort"];
                clientPort=[userDefaults valueForKey:@"pingtaiPort"];
            }
        }
        if (indexPath.row==2) {
            paramTextField.infoTextFieldType=InfoTextFieldTypeServerIP;
            if ([userDefaults valueForKey:@"serverIP"]!=nil) {
                paramTextField.text=[userDefaults valueForKey:@"serverIP"];
                serverIP=[userDefaults valueForKey:@"serverIP"];
            }
        }
        if (indexPath.row==3) {
            paramTextField.infoTextFieldType=InfoTextFieldTypeServerPort;
            if ([userDefaults valueForKey:@"serverPort"]!=nil) {
                paramTextField.text=[userDefaults valueForKey:@"serverPort"];
                serverPort=[userDefaults valueForKey:@"serverPort"];
            }
        }

    }
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    BOOL isEn=cell.userInteractionEnabled;
    [paramTextField addTarget:self action:@selector(getTextFieldResult:) forControlEvents:UIControlEventEditingChanged];

    return cell;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
//    InfoTextField *textField=(InfoTextField *)[cell viewWithTag:2000];
//    if (self.sysInfoType==SysSettingTypeUpdatePwd) {
//        NSLog(@"update pwd");
//        NSLog(@"第%d行",indexPath.row);
//        if (indexPath.row==0) {
//            textField.infoTextFieldType=InfoTextFieldTypeOldPWD;
//        }
//        if (indexPath.row==1) {
//            textField.infoTextFieldType=InfoTextFieldTypeNewPWD;
//        }
//        if (indexPath.row==2) {
//            textField.infoTextFieldType=InfoTextFieldTypeNewPWD2;
//        }
//        
//        
//    }
//    if (self.sysInfoType==SysSettingTypeUpdateParams) {
//        NSLog(@"update params");
//        if (indexPath.row==0) {
//            textField.infoTextFieldType=InfoTextFieldTypePingIP;
//        }
//        if (indexPath.row==1) {
//            textField.infoTextFieldType=InfoTextFieldTypePingPort;
//        }
//        if (indexPath.row==2) {
//            textField.infoTextFieldType=InfoTextFieldTypeServerIP;
//        }
//        if (indexPath.row==3) {
//            textField.infoTextFieldType=InfoTextFieldTypeServerPort;
//        }
//    }
//    
//    [textField addTarget:self action:@selector(getTextFieldResult:) forControlEvents:UIControlEventEditingChanged];
    
    

    
}





@end
