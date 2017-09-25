//
//  CustomMenuItem.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/24.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "CustomMenuItem.h"

@interface CustomMenuItem ()
@property (weak, nonatomic) IBOutlet UIView *markView;
@end

@implementation CustomMenuItem

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)menuItemNormalStyle {
    self.lbTitle.textColor = [UIColor grayColor];
    self.markView.backgroundColor = [UIColor grayColor];
}

- (void)menuItemSelectedStyle {
    self.lbTitle.textColor = [UIColor redColor];
    self.markView.backgroundColor = [UIColor redColor];
}

@end
