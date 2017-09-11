//
//  LightListCellTableViewCell.m
//  StreetLight
//
//  Created by four-faith on 17/8/8.
//  Copyright © 2017年 street. All rights reserved.
//

#import "LightListCell.h"

@implementation LightListCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

-(void)setLight:(Light *)light
{

    self.lightCodeLabel.numberOfLines=0;
    self.lightAddressValueLabel.numberOfLines=0;
    self.titleLabel.numberOfLines=0;
    _light=light;
    self.titleLabel.text=light.title;
   // self.iconView.image=[UIImage imageNamed:light.titleIcon];
    self.lightCodeValue.text=light.lightCode;
    self.lightAddressValueLabel.text=light.lightAddress;
    
    
}

-(CGSize)sizeThatFits:(CGSize)size
{
    CGFloat totalHeight = 0;
    totalHeight += [self.titleLabel sizeThatFits:size].height;
    totalHeight += [self.line sizeThatFits:size].height;
    totalHeight += [self.lightCodeValue sizeThatFits:size].height;
    totalHeight += [self.lightAddressValueLabel sizeThatFits:size].height;
    totalHeight += 60; // margins
    return CGSizeMake(size.width, totalHeight);

}
@end
