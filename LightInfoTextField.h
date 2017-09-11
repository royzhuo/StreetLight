//
//  LightInfoTextField.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/11.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LightInfoTextFieldType){
    
    LightInfoTextFieldTypeNum=1,
    LightInfoTextFieldTypeName=2,
    LightInfoTextFieldTypeAddress=3,
    LightInfoTextFieldTypeLightType=4,
    LightInfoTextFieldTypeAccertCode=5,
    LightInfoTextFieldTypeWangGuan=6,
    LightInfoTextFieldTypeBatteryCode=7
    
};

@interface LightInfoTextField : UITextField

@property(nonatomic,assign) LightInfoTextFieldType lightInfoTextType;

@property(nonatomic,assign) int row;
@end
