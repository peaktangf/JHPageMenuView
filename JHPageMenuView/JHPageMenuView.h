//
//  JHPageMenuView.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHPageMenuView, JHPageMenuItem, JHPageDecorateView;

@protocol JHPageMenuViewDataSource <NSObject>
@required

/**
 告知 "JHMenuView" 需要多少个菜单
 
 @param menuView JHPageMenuView
 @return 菜单个数
 */
- (NSInteger)numbersOfItemsInMenuView:(JHPageMenuView *)menuView;

/**
 告知 "JHMenuView" 每个菜单的内容视图
 
 @param menuView JHPageMenuView
 @param index 当前需要展示内容视图的位置
 @return 菜单内容视图
 */
- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView menuCellForItemAtIndex:(NSInteger)index;

@optional
/**
 告知 "JHMenuView" 每个菜单的装饰视图
 
 @param menuView JHPageMenuView
 @param index 当前需要展示装饰视图的位置
 @return 菜单装饰视图
 */
- (JHPageMenuItem *)menuView:(JHPageMenuView *)menuView decorateCellForItemAtIndex:(NSInteger)index;

@end

@protocol JHPageMenuViewDelegate <NSObject>
@optional

/**
 告知 "JHMenuView" 每个菜单的大小
 
 @param menuView JHPageMenuView
 @param index 当前显示菜单的位置
 @return 大小
 */
- (CGSize)menuView:(JHPageMenuView *)menuView sizeForItemAtIndex:(NSInteger)index;

/**
 当点击菜单子视图的时候，你可能需要做些事情，可以在这里面实现
 
 @param menuView JHPageMenuView
 @param index 当前点击的菜单视图的位置
 */
- (void)menuView:(JHPageMenuView *)menuView didSelectIndex:(NSInteger)index;

/**
 当菜单切换完成之后，你可能需要做些事情，可以在这里面实现
 
 @param menuView JHPageMenuView
 @param index 当前切换到的菜单视图的位置
 */
- (void)menuView:(JHPageMenuView *)menuView didAnimationIndex:(NSInteger)index;

@end

@interface JHPageMenuView : UIView<JHPageMenuViewDelegate>

@property (nonatomic, weak) id<JHPageMenuViewDelegate> delegate;
@property (nonatomic, weak) id<JHPageMenuViewDataSource> dataSource;

/** 
 菜单collectionView视图 
 */
@property (nonatomic, strong) UICollectionView *menuCollectionView;

/** 
 装饰collectionView视图 
 */
@property (nonatomic, strong) UICollectionView *decorateCollectionView;

/**
 设置选中的菜单

 @param index 位置
 */
- (void)selectItemAtIndex:(NSInteger)index;

- (void)moveFormIndex:(NSInteger)formIndex toIndex:(NSInteger)toIndex;

@end
