//
//  JHPageDecorateBuiltInItem.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/23.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPageMenuConstant.h"

@interface JHPageDecorateBuiltInItem : UIView

@property (nonatomic, assign) JHPageMenuScrollDirection scrollDirection;
@property (nonatomic, assign) JHPageDecorateStyle decorateStyle;
@property (nonatomic, strong) UIColor *decorateColor;
@property (nonatomic, assign) CGSize decorateSize;

@end
