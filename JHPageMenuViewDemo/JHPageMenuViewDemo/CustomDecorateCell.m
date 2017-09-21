//
//  CustomDecorateCell.m
//  JHMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/20.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "CustomDecorateCell.h"

@interface CustomDecorateCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation CustomDecorateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.backgroundColor = [UIColor clearColor];
    self.bgView.layer.borderColor = [UIColor redColor].CGColor;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 10;
}

@end
