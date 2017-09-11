//
//  LightAddViewController.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/14.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightAddViewController.h"
#import "ErWeiCodeBtn.h"
#import "LightInfoTextField.h"
#import "ErWeiMaViewController.h"
#import "LightType.h"
#import "LightManagerController.h"

@interface LightAddViewController()<UITableViewDelegate,UITableViewDataSource,ErWeiMaCodeDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSMutableArray *titles;
    NSMutableArray *values;
    NSArray *lightTypes;
    NSMutableArray *lightTypeModels;
    
    NSString *_num;
    NSString *_name;
    NSString *_address;
    int _lightType;
    NSString *_accsetCode;
    NSString *_wangGuan;
    NSString *_batteryCode;
    LightType *tempLightType;
    
    UIView *zhezaoView;
    
    UITapGestureRecognizer *tap;
}

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,strong) UIButton *ranBtn;
@end

@implementation LightAddViewController

-(void)viewDidLoad
{
    
self.navigationItem.title=@"路灯添加";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    lightTypeModels=[NSMutableArray array];
    
    titles=[NSMutableArray arrayWithObjects:@"路灯编码",@"路灯名称",@"安装位置",@"路灯类型",@"资产编码",@"网关",@"蓄电池编码", nil];
    lightTypes=@[@"太阳能路灯",@"风光互补路灯",@"磁悬浮路灯",@"市光电能路灯",@"市电路灯",@"观景路灯",@"隧道路灯"];
    for (int i=1; i<=7; i++) {
        LightType *lightType=[[LightType alloc]initWithTypeId:i withValue:lightTypes[i-1]];
        [lightTypeModels addObject:lightType];
    }
    
    
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"houtui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
    [leftButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    self.tabeView.delegate=self;
    self.tabeView.dataSource=self;
    
    [self initTableViewFootView];
    [self initPickView];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showLightTypeView)];
}

//返回
-(void)leftView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



#pragma mark tebleview协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0||indexPath.row==6) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        ErWeiCodeBtn *erweiMaBtn=(ErWeiCodeBtn *)[cell viewWithTag:1200];
        [erweiMaBtn addTarget:self action:@selector(getErWeiMa:) forControlEvents:UIControlEventTouchUpInside];
        erweiMaBtn.indexPath=indexPath;
        UILabel *title=[cell viewWithTag:1000];
        title.text=titles[indexPath.row];
        LightInfoTextField *textField=(LightInfoTextField *)[cell viewWithTag:1100];
        [textField addTarget:self action:@selector(getLightSomeInfo:) forControlEvents:UIControlEventEditingChanged];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (indexPath.row==0) {
            textField.lightInfoTextType=LightInfoTextFieldTypeNum;
            if (_num!=nil) {
                textField.text=_num;
            }
        }
        if (indexPath.row==6) {
            textField.lightInfoTextType=LightInfoTextFieldTypeBatteryCode;
            if (_batteryCode!=nil) {
                textField.text=_batteryCode;
            }
        }
        return cell;
    }else if(indexPath.row==3){
         UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *titleLabel=[cell viewWithTag:1000];
        titleLabel.text=titles[indexPath.row];
        UIButton *button=(UIButton *)[cell viewWithTag:1100];
        button.layer.cornerRadius=8;
        button.layer.borderWidth=0.5;
        button.layer.borderColor=CGColorRGB(232, 232, 232);
        [button addTarget:self action:@selector(showLightTypeView) forControlEvents:UIControlEventTouchUpInside];
        if (_lightType!=0) {
            LightType *ligthType=lightTypeModels[_lightType-1];
            [button setTitle:ligthType.typeValue forState:UIControlStateNormal];
        }else{
            [button setTitle:@"点击选择路灯类型" forState:UIControlStateNormal];
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        LightInfoTextField *textField=(LightInfoTextField *)[cell viewWithTag:1100];
        [textField addTarget:self action:@selector(getLightSomeInfo:) forControlEvents:UIControlEventEditingChanged];
        UILabel *titleLabel=[cell viewWithTag:1000];
        titleLabel.text=titles[indexPath.row];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (indexPath.row==1) {
            if (_name!=nil) {
                textField.text=_name;
            }
            textField.lightInfoTextType=LightInfoTextFieldTypeName;
        }
        if (indexPath.row==2) {
            textField.lightInfoTextType=LightInfoTextFieldTypeAddress;
            if (_address!=nil) {
                textField.text=_address;
            }
        }
        if (indexPath.row==4) {
            if (_accsetCode!=nil) {
                textField.text=_accsetCode;
            }
            textField.lightInfoTextType=LightInfoTextFieldTypeAccertCode;
        }
        if (indexPath.row==5) {
            if (_wangGuan) {
                textField.text=_wangGuan;
            }
            textField.lightInfoTextType=LightInfoTextFieldTypeWangGuan;
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }

        return cell;
    
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark pickView协议
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  lightTypeModels.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title=nil;
    LightType *lightType=(lightTypeModels[row]);
    title=lightType.typeValue;
    return title;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    LightType *lightType=(lightTypeModels[row]);
    tempLightType=lightType;
    NSLog(@"选了:%@",lightType.typeValue);
}


#pragma mark textField协议
//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    LightInfoTextField *infoTextField=(LightInfoTextField *)textField;
//    if (infoTextField.lightInfoTextType==LightInfoTextFieldTypeLightType) {
//        [UIView animateWithDuration:0.3 animations:^{
//            zhezaoView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        } completion:^(BOOL finished) {
//            self.topView.alpha=1;
//            
//        }];
//        return false;
//    }else{
//    return true;
//    }
//    
//}


#pragma mark 其他



-(void)initPickView
{
    zhezaoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    zhezaoView.backgroundColor=YLSColorAlpha(0, 0, 0, 0.4);
    [self.view addSubview:zhezaoView];
    
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, zhezaoView.frame.size.height-zhezaoView.frame.size.height*0.4, self.view.frame.size.width, zhezaoView.frame.size.height*0.4)];
//    self.topView=[[UIView alloc]initWithFrame:YLSRect(0, 667/667, 1, 250/667)];
    self.topView.backgroundColor=[UIColor whiteColor];
    //[self.view addSubview:self.topView];
    [zhezaoView addSubview:_topView];
    
    self.doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(finishedSelectedLightType) forControlEvents:UIControlEventTouchUpInside];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [self.doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    float donuBtnWidth=self.topView.frame.size.width*0.2;
//    self.doneBtn.frame=CGRectMake(self.topView.frame.size.width-donuBtnWidth+10, 0, donuBtnWidth, donuBtnWidth);
    self.doneBtn.frame=YLSRect(320/375, 5/667, 50/375, 40/667);
    [self.topView addSubview:self.doneBtn];
    
    self.ranBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ranBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.ranBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.ranBtn setFrame:YLSRect(5/375, 5/667, 100/375, 40/667)];
    [self.ranBtn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:self.ranBtn];
    

    self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.doneBtn.frame.size.height, self.topView.frame.size.width, self.topView.frame.size.height-self.doneBtn.frame.size.height)];
    self.pickerView.delegate=self;
    self.pickerView.dataSource=self;
    self.pickerView.backgroundColor=RGB(240, 239, 245);
    [self.topView addSubview:self.pickerView];
    
    

}

-(void) showLightTypeView
{

    [UIView animateWithDuration:0.3 animations:^{
        zhezaoView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        self.topView.alpha=1;
        
    }];

}

-(void)finishedSelectedLightType
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
        zhezaoView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (tempLightType) {
            _lightType=tempLightType.typeId;
            [self.tabeView reloadData];
        }
    }];


}
-(void)quxiao
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
        zhezaoView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (tempLightType) {
            tempLightType=nil;
        }
    }];

    

}

//添加保存按钮
-(void)initTableViewFootView
{
    UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabeView.frame.size.width, 80)];
    //footView.backgroundColor=[UIColor redColor];
    
    UIButton *tuiChuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    int tuiChuBtnWidth=ScreenWidth-30;
    int tuiChuBtnHeight=footView.frame.size.height/2;
    tuiChuBtn.frame=CGRectMake((ScreenWidth-tuiChuBtnWidth)/2, tuiChuBtnHeight/2, tuiChuBtnWidth, tuiChuBtnHeight);
    [tuiChuBtn setTitle:@"保存" forState:UIControlStateNormal];
    [tuiChuBtn setTintColor:[UIColor whiteColor]];
    [tuiChuBtn setBackgroundColor:RGB(0, 205, 102)];
    tuiChuBtn.layer.cornerRadius=10;
    [footView addSubview:tuiChuBtn];
    //添加点击事件
    [tuiChuBtn addTarget:self action:@selector(updateLightInfo) forControlEvents:UIControlEventTouchUpInside];
    self.tabeView.tableFooterView=footView;
    
}

//获取二维码
-(void)getErWeiMa:(ErWeiCodeBtn *)sender
{
    NSLog(@"%@",sender);
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[ErWeiMaViewController class]]) {
            ErWeiMaViewController *erweimaview=(ErWeiMaViewController *)viewController;
            [erweimaview setHidesBottomBarWhenPushed:YES];
            self.delegate=erweimaview;
            //获取页面上有的数据，防止页面跳转丢失
            NSMutableDictionary *params=[NSMutableDictionary dictionary];
            if (_name!=nil) {
                [params setObject:_name forKey:@"_name"];
            }
            if (_lightType!=0) {
                [params setObject:[NSString stringWithFormat:@"%d",_lightType] forKey:@"_lightType"];
            }
            if (_accsetCode!=nil) {
                [params setObject:_accsetCode forKey:@"_accsetCode"];
            }
            if (_wangGuan!=nil) {
                [params setObject:_wangGuan forKey:@"_wangGuan"];
            }
            if (sender.indexPath.row==0) {
                if (_batteryCode!=nil) {
                    [params setObject:_batteryCode forKey:@"_batteryCode"];
                }
                [self.delegate setLightAddViewType:ErWeiMaTypeLight withParams:params];
                //[self.delegate setLightAddViewType:ErWeiMaTypeLight];
            }
            if (sender.indexPath.row==6) {
                if (_num!=nil) {
                    [params setObject:_num forKey:@"_num"];
                }
                [self.delegate setLightAddViewType:ErWeiMaTypeBattery withParams:params];
            }

            [self.navigationController popToViewController:erweimaview animated:YES];

        }
    }
}

-(void)getLightSomeInfo:(LightInfoTextField *)sender
{

    LightInfoTextField *lightTextField=(LightInfoTextField *)sender;
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeNum) {
        _num=lightTextField.text;
        NSLog(@"num:%@",_num);
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeName) {
        _name=lightTextField.text;
        NSLog(@"name:%@",_name);
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeAddress) {
        _address=lightTextField.text;
        NSLog(@"address:%@",_address);
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeAccertCode) {
        _accsetCode=lightTextField.text;
        NSLog(@"accsetcode:%@",_accsetCode);
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeWangGuan) {
        _wangGuan=lightTextField.text;
        NSLog(@"wangguan:%@",_wangGuan);
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeBatteryCode) {
        _batteryCode=lightTextField.text;
        NSLog(@"battery:%@",_batteryCode);
    }


}
//路灯添加
-(void)updateLightInfo
{
    if([self checkParams]){
        NSLog(@"保存");
        NSString *params=[NSString stringWithFormat:@"?lampname=%@&lampnum=%@&lampaddress=%@&cityname=%@&guardiancode=%@&assetscode=%@&gwid=%@&inccode=%@&batterycode=%@&longitude=%.6f&latitude=%.6f&lamptype=%d&toKen=%@",_name,_num,_address,self.city,[User sharedInstance].guardiancode,_accsetCode,_wangGuan,[User sharedInstance].inccode,_batteryCode,self.longitude,self.latitude,_lightType,[User sharedInstance].token];
        [[HttpTool sharedInstance] Post:lampAdd params:params success:^(id responseObj) {
            if (responseObj) {
                NSLog(@"%@",responseObj);
                BOOL isAddSuccess=[[responseObj valueForKey:@"success"]boolValue];
                if (isAddSuccess) {
                    [self showSuccessTip:@"路灯添加成功" timeOut:0.3f];
                    if (self.navigationController!=nil&& self.navigationController.viewControllers!=nil) {
                        for (UIViewController *viewController in self.navigationController.viewControllers) {
                            if ([viewController isKindOfClass:[LightManagerController class]]) {
                                LightManagerController *ligmager=(LightManagerController *)viewController;
                                MapViewController *mapViewCont=ligmager.mapViewController;
                                self.delegate=mapViewCont;
                                [self.delegate isLightAddSuccess:YES withLatitude:self.latitude withLongitude:self.longitude];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }
                    }
                }else{
                    [self showFailureTip:@"添加失败" detail:nil timeOut:0.3f];
                    int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
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
    }
    
}

-(BOOL)checkParams
{
    if (_num==nil) {
        [self showMessageTip:@"路灯编码不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if(_name==nil){
        [self showMessageTip:@"路灯名称不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if(_address==nil){
        [self showMessageTip:@"安装位置不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if(_lightType==0){
        [self showMessageTip:@"路灯类型不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if(_accsetCode==nil){
        [self showMessageTip:@"资产编码不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if(_wangGuan==nil){
        [self showMessageTip:@"网关不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if(_batteryCode==nil){
        [self showMessageTip:@"蓄电池编码不能为空" detail:nil timeOut:0.3f];
        return false;
    }else if( ![NSString isCheckNullByArray:@[_num,_name,_address,[NSString stringWithFormat:@"%d",_lightType],_accsetCode,_wangGuan,_batteryCode]]){
        if (![NSString isCheckLampNum:_num]) {
            [self showFailureTip:@"请填写正确路灯编码" detail:nil timeOut:0.3f];
            return false;
        }
        if (_num.length!=8) {
            [self showMessageTip:@"路灯编码长度为8" detail:nil timeOut:0.3f];
            return false;
        }
        if (_wangGuan.length!=8) {
            [self showMessageTip:@"网关长度为8" detail:nil timeOut:0.3f];
            return false;
        }

        
        return true;
    }else{
        [self showMessageTip:@"内容不能为空,请补全" detail:nil timeOut:0.3f];
        return false;
    }

}

#pragma mark 二维码协议

-(void)getErWeiMaValueWithLightCode:(NSString *)lightCode OrBatterCode:(NSString *)batteryCode withAddress:(NSString *)address withCity:(NSString *)city withLongitude:(double)longitude withlatitude:(double)latitude withLightParams:(NSMutableDictionary *)params
{

    _address=address;
    if (lightCode!=nil) {
        _num=lightCode;
        if ([params valueForKey:@"_batteryCode"]) {
            _batteryCode=[params valueForKey:@"_batteryCode"];
        }
    }
    if (batteryCode!=nil) {
        _batteryCode=batteryCode;
        if ([params valueForKey:@"_num"]) {
            _num=[params valueForKey:@"_num"];
        }
    }
    self.longitude=longitude;
    self.latitude=latitude;
    self.city=city;

    if ([params valueForKey:@"_name"]) {
        _name=[params valueForKey:@"_name"];
    }
    if ([params valueForKey:@"_lightType"]) {
        _lightType=[[params valueForKey:@"_lightType"]intValue];
    }
    if ([params valueForKey:@"_accsetCode"]) {
        _accsetCode=[params valueForKey:@"_accsetCode"];
    }
    if ([params valueForKey:@"_wangGuan"]) {
        _wangGuan=[params valueForKey:@"_wangGuan"];
    }
}
-(void)setBatterCode:(NSString *)batteryCode
{
    NSLog(@"batteryCode:%@",batteryCode);
}
@end
