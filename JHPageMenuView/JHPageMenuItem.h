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
 获取collectionView对应index的collectionCell

 @param collectionView collectionView
 @param index index
 @return collectionCell
 */
+ (instancetype)collectionView:(UICollectionView *)collectionView itemForIndex:(NSInteger)index;

/**
 设置菜单是否选中

 @param selected 是否选中
 @param animation 是否执行动画
 */
- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation;

@end
