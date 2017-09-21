//
//  JHPageMenuItem.h
//  JHPageMenuViewDemo
//
//  Created by 谭高丰 on 2017/9/21.
//  Copyright © 2017年 谭高丰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPageMenuItem : UICollectionViewCell

+ (void)registerMenuItemNibCollectionView:(UICollectionView *)collectionView;
+ (instancetype)collectionView:(UICollectionView *)collectionView itemForIndexPath:(NSIndexPath *)indexPath;


@end
