//
//  WarnCell.h
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Warn.h"

@interface WarnCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *lightNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *privinceLabel;


@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property(weak,nonatomic) Warn *warn;


@end
