//
//  CustomDecorateCell.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/22.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "CustomDecorateCell.h"

@interface CustomDecorateCell ()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end

@implementation CustomDecorateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)menuItemNormalStyle {
    self.lineView.hidden = YES;
}

- (void)menuItemSelectedStyle {
    self.lineView.hidden = NO;
}

@end
