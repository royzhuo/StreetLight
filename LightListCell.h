//
//  LightListCellTableViewCell.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/8.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Light.h"

@interface LightListCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *lightCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *lightAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *lightCodeValue;

@property (weak, nonatomic) IBOutlet UILabel *lightAddressValueLabel;

@property(strong,nonatomic) Light *light;


@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIView *line;

@end
