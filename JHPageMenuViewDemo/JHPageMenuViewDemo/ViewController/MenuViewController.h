//
//  MenuViewController.h
//  JHMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/20.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPageMenuView.h"

@interface MenuViewController : UIViewController

/**
 菜单的滚动方向
 */
@property (nonatomic, assign) JHPageMenuScrollDirection menuScrollDirection;

/**
 装饰视图的样式
 */
@property (nonatomic, assign) JHPageDecorateStyle decorateStyle;

/**
 是否使用自定义的装饰视图
 */
@property (nonatomic, assign) BOOL isCustomDecorate;

@end
