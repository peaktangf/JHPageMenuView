//
//  CustomMenuCell.m
//  JHMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/20.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "CustomMenuCell.h"

@interface CustomMenuCell ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@end

@implementation CustomMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)menuItemNormalStyle {
    self.lbTitle.text = @"未选中";
    self.lbTitle.textColor = self.decorateStyle == JHPageDecorateStyleFlood ? [UIColor redColor] : [UIColor grayColor];
}

- (void)menuItemSelectedStyle {
    self.lbTitle.text = @"选中";
    self.lbTitle.textColor = self.decorateStyle == JHPageDecorateStyleFlood ? [UIColor whiteColor] : [UIColor redColor];
}

@end
