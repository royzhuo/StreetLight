//
//  LightInterface.h
//  路灯接口
//
//  Created by zhiyi.zhuo on 17/7/25.
//  Copyright © 2017年 street. All rights reserved.
//

//#ifndef LightInterface_h
//#define LightInterface_h
//
//
//#endif /* LightInterface_h */

//用户登入
#define login @"/lampapi/api/appUser/login"
//用户修改密码
#define updatePwd @"/lampapi/api/appUser/updatepwd"
//检查网络 照明
#define checkNet @"/lampapi/api/checkNet"
//检查网络 通信
#define checkNetSocket @"/api/checkNet"
//获取路灯区域信息
#define getRegion @"/lampapi/api/get/region"
//获取路灯信息表
#define regionLamp @"/lampapi/api/get/regionLamp"
//获取天气信息
#define lampWeather @"/lampapi/api/get/lampweather"
//获取维护人员信息
#define guardiainfo  @"/lampapi/api/get/guardiainfo"
//获取路灯警告信息列表
#define lampAlarm @"/lampapi/api/get/lampAlarm"
//日志上传
#define uploadLog @"/lampapi/api/log/add"
//路灯添加
#define lampAdd @"/lampapi/api/lamp/add"
//路灯编辑
#define lampUpdate @"/lampapi/api/lamp/update"
//路灯详情
#define lampDetail @"/lampplatform/api/lamp_param.do"
//路灯开关 亮度控制
#define lightModel @"/api/setModel"






