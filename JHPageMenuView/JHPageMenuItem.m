//
//  JHPageMenuItem.m
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import "JHPageMenuItem.h"

@implementation JHPageMenuItem

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Overwrite

- (void)menuItemSelectedStyle {
    // 告知item正常情况下的样式，自定义的菜单需要重写该方法
}

- (void)menuItemNormalStyle {
    // 告知item选中时的样式，自定义的菜单需要重写该方法
}

#pragma mark - Public

+ (void)registerItemNibCollectionView:(UICollectionView *)collectionView {
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([self class])];
}

+ (instancetype)collectionView:(UICollectionView *)collectionView itemForIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
}

- (void)setSelected:(BOOL)selected withAnimation:(BOOL)animation {
    self.itemSelected = selected;
    if (selected) {
        [self menuItemSelectedStyle];
    } else {
        [self menuItemNormalStyle];
    }
}

@end
