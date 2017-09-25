//
//  JHPageMenuItem.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPageMenuConstant.h"
@class JHPageMenuView;

@interface JHPageMenuItem : UICollectionViewCell

/** item的选中状态 */
@property (nonatomic, assign, getter=isItemSelected) BOOL itemSelected;

/**
 设置item的选中状态

 @param selected 是否选中
 @param animation 是否动画执行
 */
- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation;

/**
 初始化，推荐使用该初始化方法，内部已经帮你做了注册cell等操作
 
 @param menuView 菜单视图
 @param index index
 @return JHPageMenuItem
 */
+ (instancetype)menuView:(JHPageMenuView *)menuView itemForIndex:(NSInteger)index;

#pragma mark - 内置Item的相关属性

/** 内置标题label */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 item 未选中时的样式，可以通过这个block进行设置
 一般自定义 item 不建议使用这种方式设置样式，可以重写menuItemNormalStyle来自定义样式
 */
@property (nonatomic, copy) void(^menuItemNormalStyleBlock)(void);

/** 
 item 选中时的样式，可以通过这个block进行设置 
 一般自定义 item 不建议使用这种方式设置样式，可以重写menuItemNormalStyle来自定义样式
 */
@property (nonatomic, copy) void(^menuItemSelectedStyleBlock)(void);

/**
 告知item 从 选中 - 未选中 时执行的动画，可以通过这个block进行设置
 一般自定义 item 不建议使用这种方式设置动画，可以重写menuItemNormalStyleAnimation来自定义样式
 */
@property (nonatomic, copy) void(^menuItemNormalStyleAnimationBlock)(void);

/** 
 告知item 从 未选中 - 选中 时执行的动画，可以通过这个block进行设置 
 一般自定义 item 不建议使用这种方式设置动画，可以重写menuItemSelectedStyleAnimation来自定义样式
 */
@property (nonatomic, copy) void(^menuItemSelectedStyleAnimationBlock)(void);

@end
