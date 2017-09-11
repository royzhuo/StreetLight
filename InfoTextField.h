//
//  InfoTextField.h
//  StreetLight
//
//  Created by four-faith on 17/8/1.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InfoTextFieldType){

    InfoTextFieldTypeOldPWD=1,
    InfoTextFieldTypeNewPWD=2,
    InfoTextFieldTypeNewPWD2=3,
    InfoTextFieldTypePingIP=4,
    InfoTextFieldTypePingPort=5,
    InfoTextFieldTypeServerIP=6,
    InfoTextFieldTypeServerPort=7

};

@interface InfoTextField : UITextField

@property(assign,nonatomic) InfoTextFieldType infoTextFieldType;

@end
