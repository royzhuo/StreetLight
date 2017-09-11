//
//  LightInfoUpdate.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/9.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightInfoUpdateController.h"
#import "ErWeiCodeBtn.h"
#import "LightInfoTextField.h"
#import "LightType.h"
#import "LightManagerController.h"

@interface LightInfoUpdateController()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,ErWeiMaCodeDelegate>
{

    NSString *num;
    NSString *name;
    NSString *address;
    int lightType;
    NSString *accsetCode;
    NSString *wangGuan;
    NSString *batteryCode;
    NSArray *lightTypes;
    NSMutableArray *lightTypeModels;
    UIView *zhezaoView;
    LightType *tempLightType;

}
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)NSMutableArray *values;

@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *lightTypeMenuesView;
@property(nonatomic,strong) UIButton *doneBtn;
@property(nonatomic,strong) UIButton *ranBtn;


@end

@implementation LightInfoUpdateController

-(void)viewDidLoad
{
    //[self initTopView];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.navigationItem.title=@"路灯编辑";
    UIBarButtonItem *leftButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"houtui"] style:UIBarButtonItemStylePlain target:self action:@selector(leftView)];
    [leftButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem setLeftBarButtonItem:leftButtonItem];
    
    
    self.titles=[NSMutableArray arrayWithObjects:@"路灯编码",@"路灯名称",@"安装位置",@"路灯类型",@"资产编码",@"网关",@"蓄电池编码", nil];
    self.values=[NSMutableArray array];
    if (self.lightResult!=nil) {
        int lampType=[[self.lightResult valueForKey:@"lamptype"]intValue];
        [self.values addObject:[self.lightResult valueForKey:@"lampnum"]];
        [self.values addObject:[self.lightResult valueForKey:@"lampname"]];
        [self.values addObject:[self.lightResult valueForKey:@"lampaddress"]];
        [self.values addObject:[NSString stringWithFormat:@"%d",lampType]];
        [self.values addObject:[self.lightResult valueForKey:@"assetscode"]];
        [self.values addObject:[self.lightResult valueForKey:@"gwid"]];
        [self.values addObject:[self.lightResult valueForKey:@"batterycode"]];
        
        lightType=lampType;
        name=[self.lightResult valueForKey:@"lampname"];
        address=[self.lightResult valueForKey:@"lampaddress"];
        accsetCode=[self.lightResult valueForKey:@"assetscode"];
        wangGuan=[self.lightResult valueForKey:@"gwid"];
        batteryCode=[self.lightResult valueForKey:@"batterycode"];
        num=[self.lightResult valueForKey:@"lampnum"];
    }
    //对路灯类型业务进行封装
    lightTypeModels=[NSMutableArray array];
    lightTypes=@[@"太阳能路灯",@"风光互补路灯",@"磁悬浮路灯",@"市光电能路灯",@"市电路灯",@"观景路灯",@"隧道路灯"];
    for (int i=1; i<=7; i++) {
        LightType *lightType=[[LightType alloc]initWithTypeId:i withValue:lightTypes[i-1]];
        [lightTypeModels addObject:lightType];
    }
    [self initPickView];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellAccessoryNone;
    [self initTableViewFootView];
    
}

//返回
-(void)leftView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//加载顶部导航栏
//-(void)initTopView
//{
//    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 68)];
//    self.topView.backgroundColor=RGB(0, 205, 102);
//    float titleLabelWidth=ScreenWidth*0.4;
//    float titleLabelHeight=self.topView.frame.size.height*0.5;
//    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-titleLabelWidth)/2, (self.topView.frame.size.height-titleLabelHeight)/2, titleLabelWidth, titleLabelHeight)];
//    titleLabel.adjustsFontSizeToFitWidth=YES;
//    titleLabel.textColor=[UIColor whiteColor];
//    titleLabel.text=@"编辑路灯信息";
//    titleLabel.textAlignment=NSTextAlignmentCenter;
//    [self.topView addSubview:titleLabel];
//    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame=CGRectMake(0, (self.topView.frame.size.height-titleLabelHeight)/2, titleLabelWidth/2, titleLabelHeight);
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//    [backBtn setTintColor:[UIColor whiteColor]];
//    [self.topView addSubview:backBtn];
//    [backBtn addTarget:self action:@selector(paramsViewBack) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:self.topView];
//}

-(void)initTableViewFootView
{
    UIView *footView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 80)];
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
    self.tableView.tableFooterView=footView;

}

//返回
-(void) paramsViewBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 系统信息更新
-(void) updateLightInfo
{
    if ([self checkParams]) {
        NSString *lightId=[self.lightResult valueForKey:@"id"];
        NSString *cityname=[self.lightResult valueForKey:@"cityname"];
        double latitude=[[self.lightResult valueForKey:@"latitude"] doubleValue];
        double longitude=[[self.lightResult valueForKey:@"longitude"]doubleValue];
        NSString *params=[NSString stringWithFormat:@"?id=%@&lampname=%@&lampaddress=%@&cityname=%@&assetscode=%@&batterycode=%@&gwid=%@&longitude=%f&latitude=%f&lamptype=%d&toKen=%@&lampnum=%@",lightId,name,address,cityname,accsetCode,batteryCode,wangGuan ,longitude,latitude,
                          lightType,[User sharedInstance].token,num];
        NSLog(@"参数:%@",params);
        [[HttpTool sharedInstance]Post:lampUpdate params:params success:^(id responseObj) {
            if (responseObj) {
                if ([[responseObj valueForKey:@"success"]boolValue]) {
                    if (self.navigationController!=nil&& self.navigationController.viewControllers!=nil) {
                        for (UIViewController *viewController in self.navigationController.viewControllers) {
                            if ([viewController isKindOfClass:[LightManagerController class]]) {
                                LightManagerController *ligmager=(LightManagerController *)viewController;
                                ListViewController *lv=ligmager.listViewController;
                                self.lightInfoDelegate=lv;
                                [self.lightInfoDelegate lightInfoUpdateIsSuccess:YES];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                        }
                    }
                }else{
                    int tokenCode=[[responseObj objectForKey:@"tokenExceptionCode"]integerValue];
                    if (tokenCode!=0) {
                        [[TokenException sharedInstance]tokenExcetionWithTarget:[TokenException currentViewController] withMsg:tokenCode];
                    }
                }
            }
        } failure:^(NSError *error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
        }];
    }
    
}

//蓄电池二维码跳转
-(void)clickErWeiMa:(UIButton *)sender
{
    NSLog(@"点击了二维码");
       ErWeiMaViewController  *erWeiMaViewController=[ViewTool initViewByStoryBordName:@"LightManager" withViewId:@"erweima"];
    self.lightInfoDelegate=erWeiMaViewController;
    [self.lightInfoDelegate notifyErWeiMa:ErWeiMaTypeLightUpdate];
    [self.navigationController pushViewController:erWeiMaViewController animated:YES];
}

#pragma mark tableview协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    if (indexPath.row==6) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell.selectionStyle=UITableViewCellAccessoryNone;
        UILabel *titleLabel=[cell viewWithTag:1000];
        titleLabel.text=self.titles[indexPath.row];
        if (self.values!=nil&&self.values.count>=7) {
            LightInfoTextField *textField=(LightInfoTextField *)[cell viewWithTag:1100];
            [textField addTarget:self action:@selector(getTextFeildValue:) forControlEvents:UIControlEventEditingChanged];
            textField.text=self.values[indexPath.row];
            textField.lightInfoTextType=LightInfoTextFieldTypeBatteryCode;
        }
        
        ErWeiCodeBtn *erweimaBtn=[cell viewWithTag:1200];
        erweimaBtn.indexPath=indexPath;
        [erweimaBtn addTarget:self action:@selector(clickErWeiMa:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if(indexPath.row==3){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UILabel *titleLabel=[cell viewWithTag:1000];
        titleLabel.text=self.titles[indexPath.row];
        UIButton *button=(UIButton *)[cell viewWithTag:1100];
        button.layer.cornerRadius=8;
        button.layer.borderWidth=0.5;
        button.layer.borderColor=CGColorRGB(232, 232, 232);
        [button addTarget:self action:@selector(showLightTypeView) forControlEvents:UIControlEventTouchUpInside];
        if (lightType!=0) {
            LightType *ligthType=lightTypeModels[lightType-1];
            [button setTitle:ligthType.typeValue forState:UIControlStateNormal];
        }else{
            [button setTitle:@"点击选择路灯类型" forState:UIControlStateNormal];
        }
        
        return cell;
        
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
        cell.selectionStyle=UITableViewCellAccessoryNone;
        UILabel *titleLabel=[cell viewWithTag:1000];
        titleLabel.text=self.titles[indexPath.row];
        LightInfoTextField *textField=(LightInfoTextField *)[cell viewWithTag:1100];
        [textField addTarget:self action:@selector(getTextFeildValue:) forControlEvents:UIControlEventEditingChanged];
        if (indexPath.row==0) {
            textField.enabled=NO;
            textField.lightInfoTextType=LightInfoTextFieldTypeNum;
        }
        if (indexPath.row==1) {
            textField.lightInfoTextType=LightInfoTextFieldTypeName;
        }
        if (indexPath.row==2) {
            textField.lightInfoTextType=LightInfoTextFieldTypeAddress;
        }
        if (indexPath.row==4) {
            textField.lightInfoTextType=LightInfoTextFieldTypeAccertCode;
        }
        if (indexPath.row==5) {
            textField.lightInfoTextType=LightInfoTextFieldTypeWangGuan;
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }
        if (self.values!=nil&&self.values.count>=7) {
            textField.text=self.values[indexPath.row];
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

#pragma mark 其他

//加载路灯下拉菜单
-(void)initPickView
{
    zhezaoView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    zhezaoView.backgroundColor=YLSColorAlpha(0, 0, 0, 0.4);
    [self.view addSubview:zhezaoView];
    
    self.lightTypeMenuesView=[[UIView alloc]initWithFrame:CGRectMake(0, zhezaoView.frame.size.height-zhezaoView.frame.size.height*0.4, self.view.frame.size.width, zhezaoView.frame.size.height*0.4)];
    self.lightTypeMenuesView.backgroundColor=[UIColor whiteColor];
    [zhezaoView addSubview:_lightTypeMenuesView];
    
    self.doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.doneBtn addTarget:self action:@selector(finishedSelectedLightType) forControlEvents:UIControlEventTouchUpInside];
    [self.doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.doneBtn.frame=YLSRect(320/375, 5/667, 50/375, 40/667);
    [self.lightTypeMenuesView addSubview:self.doneBtn];
    
    self.ranBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ranBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.ranBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.ranBtn setFrame:YLSRect(5/375, 5/667, 100/375, 40/667)];
    [self.ranBtn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [self.lightTypeMenuesView addSubview:self.ranBtn];
    
    
    self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, self.doneBtn.frame.size.height, self.lightTypeMenuesView.frame.size.width, self.lightTypeMenuesView.frame.size.height-self.doneBtn.frame.size.height)];
    self.pickerView.delegate=self;
    self.pickerView.dataSource=self;
    self.pickerView.backgroundColor=RGB(240, 239, 245);
    [self.lightTypeMenuesView addSubview:self.pickerView];
    
    
    
}

//显示下来菜单
-(void) showLightTypeView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        zhezaoView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
}

//下拉菜单取消
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

//下拉菜单完成
-(void)finishedSelectedLightType
{
    [UIView animateWithDuration:0.3 animations:^{
        
        
        zhezaoView.frame=CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (tempLightType) {
            lightType=tempLightType.typeId;
            [self.values replaceObjectAtIndex:3 withObject:lightTypes];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
            NSArray<NSIndexPath *> *indexPaths=@[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}


//获取表单的值
-(void)getTextFeildValue:(UITextField *)sender
{
    LightInfoTextField *lightTextField=(LightInfoTextField *)sender;
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeName) {
        name=lightTextField.text;
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeAddress) {
        address=lightTextField.text;
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeLightType) {
        lightType=[(lightTextField.text)intValue];
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeAccertCode) {
        accsetCode=lightTextField.text;
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeWangGuan) {
        wangGuan=lightTextField.text;
    }
    if (lightTextField.lightInfoTextType==LightInfoTextFieldTypeBatteryCode) {
        batteryCode=lightTextField.text;
    }
    
}

//表单值非空验证
-(BOOL)checkParams
{

    if( ![NSString isCheckNullByArray:@[name,address,[NSString stringWithFormat:@"%d",lightType],accsetCode,wangGuan,batteryCode]]){
            if (wangGuan.length!=8) {
            [self showMessageTip:@"网关长度为8" detail:nil timeOut:0.3f];
            return false;
        }

        return true;
    }else{
        [self showMessageTip:@"内容不能为空" detail:nil timeOut:0.3f];
        return false;
    }

}

-(void)setBatterCode:(NSString *)lightUpdateBatteryCode
{
    NSLog(@"%@",lightUpdateBatteryCode);
    if (self.values!=nil) {
        
        batteryCode=lightUpdateBatteryCode;
        [self.values replaceObjectAtIndex:6 withObject:lightUpdateBatteryCode];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
        NSArray<NSIndexPath *> *indexPaths=@[indexPath];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }

}
@end
