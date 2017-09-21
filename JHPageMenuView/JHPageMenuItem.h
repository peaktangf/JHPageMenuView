//
//  JHPageMenuItem.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPageMenuItem : UICollectionViewCell

/**
 item的选中状态
 */
@property (nonatomic, assign, getter=isItemSelected) BOOL itemSelected;

/**
 注册collectionView对应的collectionCell

 @param collectionView collectionView
 */
+ (void)registerMenuItemNibCollectionView:(UICollectionView *)collectionView;

/**
 获取collectionView对应indexPath的collectionCell

 @param collectionView collectionView
 @param indexPath indexPath
 @return collectionCell
 */
+ (instancetype)collectionView:(UICollectionView *)collectionView itemForIndexPath:(NSIndexPath *)indexPath;

/**
 告知菜单正常情况下的样式，自定义的菜单需要重写该方法
 */
- (void)menuItemNormalStyle;

/**
 告知菜单选中时的样式，自定义的菜单需要重写该方法
 */
- (void)menuItemSelectedStyle;

/**
 设置菜单是否选中

 @param selected 是否选中
 @param animation 是否执行动画
 */
- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation;

@end
