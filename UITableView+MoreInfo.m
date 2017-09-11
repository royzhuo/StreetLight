//
//  UITableView+MoreInfo.m
//  StreetLight
//
//  Created by zhiyi.zhuo on 17/8/9.
//  Copyright © 2017年 street. All rights reserved.
//

#import "UITableView+MoreInfo.h"

@implementation UITableView (MoreInfo)
-(void)tableViewDisplayWitMsg:(NSString *)message ifNecessaryForRowCount:(NSUInteger)rowCount
{
    if (rowCount == 0) {
        // Display a message when the table is empty
        // 没有数据的时候，UILabel的显示样式
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.text = message;
        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];
        
        self.backgroundView = messageLabel;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}
@end
