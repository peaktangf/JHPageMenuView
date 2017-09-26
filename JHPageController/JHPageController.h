//
//  JHPageController.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/26.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPageMenuView.h"
@class JHPageController;

/**
 菜单的位置类型
 */
typedef NS_ENUM(NSInteger, JHPageMenuLocationStyle) {
    JHPageMenuLocationStyleTop,    // 菜单在顶部
    JHPageMenuLocationStyleLeft,   // 菜单在左边
    JHPageMenuLocationStyleBottom, // 菜单在底部
    JHPageMenuLocationStyleRight   // 菜单在右边
};

@protocol JHPageControllerDataSource <NSObject>
@required

/**
 告知 "JHPageController" 需要多少个子控制器

 @param pageController JHPageController
 @return 子控制器个数
 */
- (NSInteger)numbersOfViewControllerInPageController:(JHPageController *)pageController;

/**
 通过对应的子控制器获取其在数据源中的下标

 @param viewController 子控制器
 @return 当前自控制器在数据源中的位置
 */
- (NSInteger)indexOfViewController:(UIViewController *)viewController;

/**
 告知 "JHPageController" 需要显示的每个子控制器

 @param pageController JHPageController
 @param index 下标
 @return 子控制器
 */
- (UIViewController *)pageController:(JHPageController *)pageController viewContrlllerAtIndex:(NSInteger)index;

/**
 告知 "JHPageController" 需要显示的每个菜单的Item

 @param pageController JHPageController
 @param menuView JHPageMenuView
 @param index 下标
 @return 菜单Item
 */
- (JHPageMenuItem *)pageController:(JHPageController *)pageController menuView:(JHPageMenuView *)menuView menuItemAtIndex:(NSInteger)index;

@optional

/**
 告知 "JHPageController" 的 "JHMenuView" 需要显示的装饰器视图，如果实现了这个方法，且返回的装饰器视图不为nil，装饰器视图就会使用自定义的，设置的内置装饰器样式将不会生效

 @param pageController JHPageController
 @param menuView JHPageMenuView
 @return 装饰器
 */
- (UIView *)decorateItemInPageController:(JHPageController *)pageController menuView:(JHPageMenuView *)menuView;

@end

@protocol JHPageControllerDelegate <NSObject>

/**
 当子控制器将要进入用户的视线时调用，在这个时候如果想要做一些准备事情，可以在这个里面设置

 @param pageController JHPageController
 @param index 将要出现的子控制器的下标
 */
- (void)pageController:(JHPageController *)pageController willEnterViewControllerAtIndex:(NSInteger)index;

/**
 当子控制器已经进入用户的视线时调用，在这个时候如果想要做一些事情，可以在这个里面设置

 @param pageController JHPageController
 @param index 已经出现的子控制器的下标
 */
- (void)pageController:(JHPageController *)pageController didEnterViewControllerAtIndex:(NSInteger)index;

@end

@interface JHPageController : UIViewController

/** 代理 */
@property (nonatomic, weak) id<JHPageControllerDataSource> dataSource;
@property (nonatomic, weak) id<JHPageControllerDelegate> delegate;
/** 设置当前选中的下标 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 菜单背景颜色，默认为 groupTableViewBackgroundColor */
@property (nonatomic, strong) UIColor *menuBackgroundColor;
/** 菜单单元格大小，默认为CGRectZero，所以一定要设置 */
@property (nonatomic, assign) CGSize menuSize;
/** 内置的装饰器大小，不设置的话默认和菜单大小一致 */
@property (nonatomic, assign) CGSize decorateSize;
/** 内置的装饰器样式，默认为JHPageDecorateStyleDefault，当设置了自定义的装饰器时，设置的该属性不会生效 */
@property (nonatomic, assign) JHPageDecorateStyle decorateStyle;
/** 内置的装饰器样式的颜色，默认为红色 */
@property (nonatomic, strong) UIColor *decorateColor;

/**
 初始化方法，推荐使用，初始化的时候就设置菜单位置类型

 @param menulocationStyle 菜单的位置，支持上下左右，默认是顶部
 @return JHPageController实例
 */
- (instancetype)initWithMenuLocationStyle:(JHPageMenuLocationStyle)menulocationStyle;

/**
 该方法用于重置刷新父控制器，该刷新包括顶部 MenuView 和 childViewControllers.
 */
- (void)reloadData;

@end
