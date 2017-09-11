//
//  WarnCell.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/21.
//  Copyright © 2017年 street. All rights reserved.
//

#import "WarnCell.h"

@implementation WarnCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setWarn:(Warn *)warn
{
    self.lightNameLabel.numberOfLines=0;
    self.stateLabel.numberOfLines=0;
    self.privinceLabel.numberOfLines=0;
    self.timeLabel.numberOfLines=0;
    
    self.lightNameLabel.text=warn.lampname;
    self.stateLabel.text=warn.alarmcontent;
    self.privinceLabel.text=warn.regionname;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *longtime=[NSString stringWithFormat:@"%ld",warn.alarmtime];
    self.timeLabel.text=[self longToString:(warn.alarmtime/1000)];
    
    //头像
    NSString *imageNmae=[NSString stringWithFormat:@"ic_lamp%d",warn.lamptype];
    self.iconView.image=[UIImage imageNamed:imageNmae];
    
    
    

}

-(NSString *)longToString:(long)dateTimeLong
{
    NSDate *dateTime = [[NSDate alloc] initWithTimeIntervalSince1970:dateTimeLong];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSLocale *formatterLocal = [[NSLocale alloc] initWithLocaleIdentifier:@"en_us"];
    [formatter setLocale:formatterLocal];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:dateTime];
    return dateString;
}
@end
